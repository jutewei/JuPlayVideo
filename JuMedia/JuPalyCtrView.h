//
//  JuPalyView.h
//  JuMedia
//
//  Created by Juvid on 2018/8/23.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuPalyCtrView : UIView
@property (weak, nonatomic) IBOutlet UIButton *Ju_btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *ju_labCurrentTime;
@property (weak, nonatomic) IBOutlet UISlider *ju_playProgress;
@property (weak, nonatomic) IBOutlet UILabel *ju_labTotalTime;
@property (weak, nonatomic) IBOutlet UIButton *ju_btnFull;

@property (nonatomic,assign) BOOL isPlay;
- (void)juPlayProgress:(NSTimeInterval)totalTime currentTime:(NSTimeInterval)currentTime LoadRange:(NSTimeInterval)loadTime;
@end
