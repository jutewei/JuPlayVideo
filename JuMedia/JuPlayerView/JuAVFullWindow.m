//
//  JuWindow.m
//  TestWindow
//
//  Created by Juvid on 2017/8/10.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuAVFullWindow.h"

@implementation JuAVFullWindow


-(instancetype)init{
    self=[super init];
    if (self) {
        self.frame=[UIScreen mainScreen].bounds;
        self.windowLevel=UIWindowLevelNormal+1;
        self.rootViewController=[UIViewController new];
        [self setBackgroundColor:[UIColor blackColor]];
        //
    }
    return self;
}
+(id)juInit{
    JuAVFullWindow *window=[[JuAVFullWindow alloc]init];
    return window;
}
-(void)shShowWindow{
    self.hidden=NO;

}
-(void)juAddView:(UIView *)view{
    [self.rootViewController.view addSubview:view];
    [self shShowWindow];
}
-(void)juHidden{
    self.hidden=YES;
    [self resignKeyWindow];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
