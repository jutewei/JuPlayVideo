//
//  JuPalyView.m
//  JuMedia
//
//  Created by Juvid on 2018/8/23.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuPalyCtrView.h"

@implementation JuPalyCtrView
-(instancetype)init{
    self=[super init];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"JuPalyCtrView" owner:self options:nil] firstObject];
        [self.ju_playProgress setThumbImage:[UIImage imageNamed:@"MoviePlayer_Slider"] forState:UIControlStateNormal];
        
    }
    return self;
}
- (void)juPlayProgress:(NSTimeInterval)totalTime currentTime:(NSTimeInterval)currentTime LoadRange:(NSTimeInterval)loadTime{
    self.ju_playProgress.value=currentTime;
    self.ju_playProgress.maximumValue=MAX(1, totalTime);
    self.ju_labTotalTime.text=[self convertTime:totalTime];
    self.ju_labCurrentTime.text=[self convertTime:currentTime];
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
-(void)setIsPlay:(BOOL)isPlay{
    self.Ju_btnPlay.selected=isPlay;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
