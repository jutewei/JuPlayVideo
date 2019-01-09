//
//  JuWindow.h
//  TestWindow
//
//  Created by Juvid on 2017/8/10.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuAVFullWindow : UIWindow
+(id)juInit;
-(void)juAddView:(UIView *)view;
-(void)shShowWindow;
-(void)juHidden;
@end
