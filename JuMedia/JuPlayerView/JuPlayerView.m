//
//  JuPlayerView.m
//  JuMedia
//
//  Created by Juvid on 2018/8/23.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuPlayerView.h"
#import "JuAVFullWindow.h"
#import "UIView+JuLayGroup.h"
@interface JuPlayerView (){
    CGRect originalFrame;
    JuAVFullWindow *ju_avFullWindow;
     __weak UIView *ju_supView;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    UIActivityIndicatorView *ju_loadActivity;
    id ju_timeObser;
}
// 拖动进度条的时候停止刷新数据
@property (nonatomic ,assign) BOOL isSeeking;
// 是否需要缓冲
@property (nonatomic, assign) BOOL isCanPlay;
// 是否需要缓冲
@property (nonatomic, assign) BOOL ju_needBuffer;
// 缓存数据
@property (nonatomic, assign) NSTimeInterval ju_loadTime;
@end


@implementation JuPlayerView


-(instancetype)init{
    self=[super init];
    if (self) {
        [self juSetting];
        [self shSetPlayer];
    }
    return self;
}
-(void)juSetting{
    self.backgroundColor = [UIColor lightGrayColor];
    self.isCanPlay = NO;
    self.ju_needBuffer = NO;
    self.isSeeking = NO;
    /**
     * 这里view用来做AVPlayer的容器
     * 完成对AVPlayer的二次封装
     * 要求 :
     * 1. 暴露视频输出的API  视频时长 当前播放时间 进度
     * 2. 暴露出易于控制的data入口  播放 暂停 进度拖动 音量 亮度 清晰度调节
     */
}
- (void)addNotificatonForPlayer{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayError:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayEnterBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
/** 移除 通知 */
- (void)removeNotification{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [center removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [center removeObserver:self];
}
/** 视频播放结束 */
- (void)videoPlayEnd:(NSNotification *)notic{
    NSLog(@"视频播放结束");
    if (ju_avFullWindow) {
        [self juTouchFull:NO];
    }
    [self juUseDelegateWith:JuAVPlayerStatusPlayEnd];
    [self.ju_player seekToTime:kCMTimeZero];
}
/** 视频异常中断 */
- (void)videoPlayError:(NSNotification *)notic{
    NSLog(@"视频中断");
    [self juUseDelegateWith:JuAVPlayerStatusPlayStop];
}
/** 进入后台 */
- (void)videoPlayEnterBack:(NSNotification *)notic{
    NSLog(@"进入后台");
    [self juUseDelegateWith:JuAVPlayerStatusEnterBack];
}
/** 返回前台 */
- (void)videoPlayBecomeActive:(NSNotification *)notic{
    NSLog(@"返回前台");
    [self juUseDelegateWith:JuAVPlayerStatusBecomeActive];
}
- (void)juUseDelegateWith:(JuAVPlayerStatus)status{
    if (self.isCanPlay == NO) {
        return;
    }
    if (self.ju_playStatus) {
        self.ju_playStatus(status);
    }
}
-(void)shSetPlayer{
    _ju_player = [[AVPlayer alloc]init];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_ju_player];
//    _playerLayer.frame = self.bounds;
    [self.layer addSublayer:_playerLayer];
    ju_loadActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:ju_loadActivity];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _playerLayer.frame = self.bounds;
    ju_loadActivity.center=self.center;
}

/**
 切换视频

 @param videoURL 视频地址
 */
- (void)juPalyerItemWithURL:(NSURL *)videoURL{
    self.isCanPlay = NO;

    [self juPause];
    [self removeNotification];
    [self removeObserverWithPlayItem:_playerItem];

    _playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    [_ju_player replaceCurrentItemWithPlayerItem:_playerItem];

    [self addObserverWithPlayItem:_playerItem];
    [self addNotificatonForPlayer];

    [self juPlay];
    [self addPlayerObserver];

}

#pragma mark - 添加 监控
/** 给player 添加 time observer */
- (void)addPlayerObserver{
    __weak typeof(self)weakSelf = self;
    ju_timeObser = [self.ju_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {

        float current = CMTimeGetSeconds(time);
        if (weakSelf.isSeeking) {
            return;
        }
        [weakSelf juPlayTotalTimes:current];
    }];
}
#pragma mark - 属性和方法
- (NSTimeInterval)ju_TotalTime{
    return CMTimeGetSeconds(_playerItem.duration);
}
/**进度*/
-(void)juPlayTotalTimes:(NSTimeInterval)current{
    if (self.ju_progress) {
        self.ju_progress(current, self.ju_TotalTime, self.ju_loadTime);
    }
}
/** 移除 time observer */
- (void)removePlayerObserver{
    [_ju_player removeTimeObserver:ju_timeObser];
}

- (void)addObserverWithPlayItem:(AVPlayerItem *)item{
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}
/** 数据处理 获取到观察到的数据 并进行处理 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    AVPlayerItem *item = object;
    if ([keyPath isEqualToString:@"status"]) {// 播放状态

        [self handleStatusWithPlayerItem:item];

    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {// 缓冲进度

        [self handleLoadedTimeRangesWithPlayerItem:item];

    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {// 跳转后没数据

        if (self.isCanPlay) {
            NSLog(@"跳转后没数据");
            self.ju_needBuffer = YES;
            [self juUseDelegateWith:JuAVPlayerStatusCacheData];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {// 跳转后有数据
        if (self.isCanPlay && self.ju_needBuffer) {

            NSLog(@"跳转后有数据");

            self.ju_needBuffer = NO;

            [self juUseDelegateWith:JuAVPlayerStatusCacheEnd];
        }

    }
}
/**
 处理 AVPlayerItem 播放状态
 AVPlayerItemStatusUnknown           状态未知
 AVPlayerItemStatusReadyToPlay       准备好播放
 AVPlayerItemStatusFailed            播放出错
 */
- (void)handleStatusWithPlayerItem:(AVPlayerItem *)item
{
    AVPlayerItemStatus status = item.status;
    switch (status) {
        case AVPlayerItemStatusReadyToPlay:   // 准备好播放
            self.isCanPlay = YES;
            [self juUseDelegateWith:JuAVPlayerStatusReadyToPlay];
            break;
        case AVPlayerItemStatusFailed:        // 播放出错
            [self juUseDelegateWith:JuAVPlayerStatusItemFailed];
            break;
        case AVPlayerItemStatusUnknown:       // 状态未知
            break;

        default:
            break;
    }

}
/** 处理缓冲进度 */
- (void)handleLoadedTimeRangesWithPlayerItem:(AVPlayerItem *)item{
    NSArray *loadArray = item.loadedTimeRanges;

    CMTimeRange range = [[loadArray firstObject] CMTimeRangeValue];

    float start = CMTimeGetSeconds(range.start);

    float duration = CMTimeGetSeconds(range.duration);

    NSTimeInterval totalTime = start + duration;// 缓存总长度

    _ju_loadTime = totalTime;
    //    NSLog(@"缓冲进度 -- %.2f",totalTime);

}
/** 移除 item 的 observer */
- (void)removeObserverWithPlayItem:(AVPlayerItem *)item{
    [item removeObserver:self forKeyPath:@"status"];
    [item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}
/** 播放 */
- (void)juPlay{
    if (self.ju_player.rate == 0) {
        [self.ju_player play];
    }
}

/** 暂停 */
- (void)juPause{
    if (self.ju_player.rate == 1.0) {
        [self.ju_player pause];
    }
}

/** 播放|暂停 */
- (void)juPlayOrPause:(void (^)(BOOL isPlay))block{
    if (self.ju_player.rate == 0) {
        [self.ju_player play];
        block(YES);
    }else if (self.ju_player.rate == 1.0) {
        [self.ju_player pause];
        block(NO);
    }else {
        NSLog(@"播放器出错");
    }
}
/** 跳动中不监听 */
- (void)juStartToSeek{
    self.isSeeking = YES;
    [self juPause];
}
- (void)juEndSeek{
    self.isSeeking = NO;
    [self juPlay];
}
/** 拖动视频进度 */
- (void)juSeekPlayerTimeTo:(NSTimeInterval)time{
    [self juStartToSeek];
    [self.ju_player seekToTime:CMTimeMake(time, 1.0) completionHandler:^(BOOL finished) {
    }];
}
- (void)juSetVolume:(float)volume{
    self.ju_player.volume=volume;
}
/**全屏切换*/
-(void)juTouchFull:(BOOL)isFull{
    if (isFull) {
        if (!ju_supView) {
            originalFrame=self.frame;
            ju_supView=self.superview;
        }
        ju_avFullWindow=[JuAVFullWindow juInit];
        [ju_avFullWindow juAddView:self];
        self.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
        [ju_avFullWindow shShowWindow];

    }else{
        [ju_avFullWindow juHidden];
        ju_avFullWindow=nil;
        [ju_supView addSubview:self];
        self.juFrame(originalFrame);
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (self->ju_avFullWindow) {
            [self->ju_avFullWindow layoutIfNeeded];
        }else{
            [self->ju_supView layoutIfNeeded];
        }
        [self layoutIfNeeded];
    }];
}

#pragma mark - 销毁 release
- (void)dealloc{
    [self removeNotification];
    [self removePlayerObserver];
    [self removeObserverWithPlayItem:self.ju_player.currentItem];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
