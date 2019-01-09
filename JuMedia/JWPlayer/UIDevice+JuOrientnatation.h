//
//  UIDevice+JWDevice.h
//  FMGAVPlayerDemo
//
//  Created by jarvis on 2016/11/12.
//  Copyright © 2016年 FMG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (JuOrientnatation)
/**
 *  强制旋转设备
 *  @param  orientation 方向
 */
+ (void)setOrientation:(UIInterfaceOrientation)orientation;
+ (BOOL)isOrientationLandscape;
@end
