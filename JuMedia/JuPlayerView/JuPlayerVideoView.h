//
//  JuPlayerVideoView.h
//  JuMedia
//
//  Created by Juvid on 2019/1/9.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JuPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuPlayerVideoView : JuPlayerView
@property (readonly, nonatomic)  UIView *ju_viePlayBox;
@property (readonly, nonatomic)  UIButton *Ju_btnPlay;
@property (readonly, nonatomic)  UILabel *ju_labCurrentTime;
@property (readonly, nonatomic)  UISlider *ju_playProgress;
@property (readonly, nonatomic)  UILabel *ju_labTotalTime;
@property (readonly, nonatomic)  UIButton *ju_btnFull;
@end

NS_ASSUME_NONNULL_END
