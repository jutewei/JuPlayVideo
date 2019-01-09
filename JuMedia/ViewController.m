//
//  ViewController.m
//  JuMedia
//
//  Created by Juvid on 2018/4/3.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "ViewController.h"
#import "JuAVPlayer.h"
#import "JuPlayer.h"
#import "JuPlayerViewController.h"
#import "JuPlayerView.h"
#import "JuPalyCtrView.h"
#import "UIView+JuLayGroup.h"
#import "JuPlayerViewController.h"

@interface ViewController ()<JuAVPlayerDelegate>{

    __weak IBOutlet JuAVPlayer *ju_vieVideo;
    __weak IBOutlet UIProgressView *ju_progressView;
    __weak IBOutlet UIButton *ju_btnPlay;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self juSetPlayerView];

//    JuPlayerViewController *vc=[[JuPlayerViewController alloc]init];
//    vc.view.frame=CGRectMake(0, 300, 414,9*414/16);
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
//    [vc creatPlayer:[NSURL URLWithString:@"http://w2.dwstatic.com/1/5/1525/127352-100-1434554639.mp4"]];
//    [vc juPlay];

   

    
//    [vew juPlay];

//    JuPlayer*player=[[JuPlayer alloc]initWithFrame:CGRectMake(0, 300, 414,9*414/16)];
//    [player updatePlayerWith:[NSURL URLWithString:@"http://w2.dwstatic.com/1/5/1525/127352-100-1434554639.mp4"]];
//    [self.view addSubview:player];
    // Do any additional setup after loading the view.
}
/**
 创建播放器视图
 */
- (void)juSetPlayerView{

    ju_vieVideo.ju_Delegate = self;
    NSString *path=[[NSBundle mainBundle]pathForResource:@"test2" ofType:@"MP4"];
     NSURL *remoteUrl = [NSURL fileURLWithPath:path];
//    NSURL *remoteUrl = [NSURL URLWithString:@"http://w2.dwstatic.com/1/5/1525/127352-100-1434554639.mp4"];
    [ju_vieVideo replacePalyerItem:remoteUrl];
}

- (void)juPlayProgress:(NSTimeInterval)totalTime currentTime:(NSTimeInterval)currentTime LoadRange:(NSTimeInterval)loadTime{
    ju_progressView.progress=currentTime/totalTime;
}
// JUAVPlayer delegate  ----- 状态提示
- (void)juPromptPlayerStatusOrErrorWith:(JUAVPlayerStatus)status
{
    switch (status) {
        case JUAVPlayerStatusLoadingVideo:// 开始准备
            break;
        case JUAVPlayerStatusPlayEnd:// 播放完成
        {
             [ju_btnPlay setTitle:@"播放" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (IBAction)juTouchPlay:(id)sender {
    if ([ju_btnPlay.currentTitle isEqual:@"播放"]) {
        [ju_vieVideo juPlay];
        [ju_btnPlay setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [ju_vieVideo juPause];
         [ju_btnPlay setTitle:@"播放" forState:UIControlStateNormal];
    }
}
- (IBAction)shTouchFull:(id)sender {
   

//    [self presentViewController:ju_vieVideo.ju_playVC animated:YES completion:nil];
}
- (IBAction)juTouchNext:(id)sender {
    JuPlayerViewController *play=[[JuPlayerViewController alloc]init];
    [self.navigationController pushViewController:play animated:YES];
}
-(BOOL)shouldAutorotate{
    return YES;
}
///< 只能写topViewController或者viewControllers.lastObject，visibleViewController会导致返回与设置不一样
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
