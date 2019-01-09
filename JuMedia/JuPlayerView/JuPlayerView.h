//
//  JuPlayerView.h
//  JuMedia
//
//  Created by Juvid on 2018/8/23.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, JuAVPlayerStatus) {
    JuAVPlayerStatusReadyToPlay = 0, // 准备好播放
    JuAVPlayerStatusLoadingVideo,    // 加载视频
    JuAVPlayerStatusPlayEnd,         // 播放结束
    JuAVPlayerStatusCacheData,       // 缓冲视频
    JuAVPlayerStatusCacheEnd,        // 缓冲结束
    JuAVPlayerStatusPlayStop,        // 播放中断 （多是没网）
    JuAVPlayerStatusItemFailed,      // 视频资源问题
    JuAVPlayerStatusEnterBack,       // 进入后台
    JuAVPlayerStatusBecomeActive,    // 从后台返回
};
typedef void(^JuPlayProgress)(NSTimeInterval currentTimes,NSTimeInterval totalTimes,NSTimeInterval loadTimes);//
typedef void(^JuPlayStatus)(JuAVPlayerStatus playStatus);//播放状态回调
@interface JuPlayerView : UIView
/**
 *  AVPlayer播放器
 */
@property (nonatomic, strong) AVPlayer *ju_player;
/**
 *  播放状态，YES为正在播放，NO为暂停
 */
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) JuPlayProgress ju_progress;

@property (nonatomic, copy) JuPlayStatus ju_playStatus;
/**
 *  播放
 */
- (void)juPlay;

/**
 *  暂停
 */
- (void)juPause;

- (void)juPalyerItemWithURL:(NSURL *)videoURL;

/**
 改变播放进度

 @param time 时间
 */
- (void)juSeekPlayerTimeTo:(NSTimeInterval)time;

/**
 停止快进或者倒退
 */
- (void)juEndSeek;
/**
 音量设置

 @param volume 音量 0为静音
 */
- (void)juSetVolume:(float)volume;

/**全屏切换*/
-(void)juFullScreen:(BOOL)isFull;


@end
