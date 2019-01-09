//
//  JuPlayerVideoView.m
//  JuMedia
//
//  Created by Juvid on 2019/1/9.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JuPlayerVideoView.h"
#import "UIView+JuLayGroup.h"
@implementation JuPlayerVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)shSetPlayControView{

    _ju_viePlayBox=[[UIView alloc]init];
    _ju_viePlayBox.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_ju_viePlayBox];
    _ju_viePlayBox.juSafeFrame(CGRectMake(0, -.01, 0, 44));


    _Ju_btnPlay=[[UIButton alloc]init];
    [_Ju_btnPlay addTarget:self action:@selector(juTouchPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_Ju_btnPlay setImage:[UIImage imageNamed:@"MoviePlayer_Stop"] forState:UIControlStateNormal];
    [_Ju_btnPlay setImage:[UIImage imageNamed:@"MoviePlayer_Play"] forState:UIControlStateSelected];
    [_ju_viePlayBox addSubview:_Ju_btnPlay];
    _Ju_btnPlay.juFrame(CGRectMake(.01, 0, 44, 0));

    _ju_labCurrentTime=[[UILabel alloc]init];
    _ju_labCurrentTime.font=[UIFont systemFontOfSize:14];
    _ju_labCurrentTime.textColor=[UIColor whiteColor];
    [_ju_viePlayBox addSubview:_ju_labCurrentTime];
    _ju_labCurrentTime.juFrame(CGRectMake(44, 0, 44, 0));



    _ju_labTotalTime=[[UILabel alloc]init];
    _ju_labTotalTime.font=[UIFont systemFontOfSize:14];
    _ju_labTotalTime.textColor=[UIColor whiteColor];
    [_ju_viePlayBox addSubview:_ju_labTotalTime];
    _ju_labTotalTime.juFrame(CGRectMake(-44, 0, 44, 0));

    _ju_playProgress=[[UISlider alloc]init];
    [_ju_playProgress addTarget:self action:@selector(juChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_ju_playProgress addTarget:self action:@selector(juChangeEnd:) forControlEvents:UIControlEventTouchUpInside];
    [_ju_playProgress setThumbImage:[UIImage imageNamed:@"MoviePlayer_Slider"] forState:UIControlStateNormal];
    [_ju_viePlayBox addSubview:_ju_playProgress];
    _ju_playProgress.juLeaSpace.toView(_ju_labCurrentTime).equal(3);
    _ju_playProgress.juTraSpace.toView(_ju_labTotalTime).equal(3);
    _ju_playProgress.juCenterY.equal(0);

    _ju_btnFull=[[UIButton alloc]init];
    [_ju_btnFull setImage:[UIImage imageNamed:@"MoviePlayer_Full"] forState:UIControlStateNormal];
    [_ju_btnFull addTarget:self action:@selector(juTouchFull:) forControlEvents:UIControlEventTouchUpInside];
    [_ju_viePlayBox addSubview:_ju_btnFull];
    _ju_btnFull.juFrame(CGRectMake(-0.01, 0, 44, 0));
    
     __weak typeof(self)weakSelf = self;
    self.ju_progress = ^(NSTimeInterval currentTime, NSTimeInterval totalTime, NSTimeInterval loadTimes) {
        weakSelf.ju_playProgress.value=currentTime;
        weakSelf.ju_playProgress.maximumValue=MAX(1, totalTime);
        weakSelf.ju_labTotalTime.text=[weakSelf convertTime:totalTime];
        weakSelf.ju_labCurrentTime.text=[weakSelf convertTime:currentTime];
    };
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
-(void)juChangeValue:(UISlider *)sender{
    NSLog(@"进度%f",sender.value);
    [self juSeekPlayerTimeTo:sender.value];
}
-(void)juChangeEnd:(UISlider *)sender{
    [self juEndSeek];
}
-(void)juPlay{
    [super juPlay];
    _Ju_btnPlay.selected=YES;
}
-(void)juPause{
    [super juPause];
    _Ju_btnPlay.selected=NO;
}
- (IBAction)juTouchPlay:(UIButton *)sender{
    if (!sender.selected) {
        [self juPlay];
    }else{
        [self juPause];
    }
}
-(void)juTouchFull:(UIButton *)sender{
    sender.selected=!sender.selected;
    [self juFullScreen:sender.selected];
}
@end
