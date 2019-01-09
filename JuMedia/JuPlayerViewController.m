//
//  JuPlayerViewController.m
//  JuMedia
//
//  Created by Juvid on 2018/8/23.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuPlayerViewController.h"
#import "JuPlayerVideoView.h"
#import "UIView+JuLayGroup.h"
#import "JuHTTPRequest.h"
@interface JuPlayerViewController ()

@end

@implementation JuPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JuPlayerVideoView *vew=[[JuPlayerVideoView alloc]init];
//    vew.frame=self.view.bounds;
    [self.view addSubview:vew];
    vew.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    NSString *path=[[NSBundle mainBundle]pathForResource:@"test" ofType:@"MOV"];
    NSURL *remoteUrl = [NSURL fileURLWithPath:path];
    [vew juPalyerItemWithURL:remoteUrl];
    [[JuHTTPRequest sharedInstance]juDownURL:@"https://raw.githubusercontent.com/jutewei/JuPlayVideo/master/JuMedia/test2.MP4" success:^(NSString *locationUrl) {
        NSLog(@"地址：%@",locationUrl);
    } failblock:^(NSError *error) {

    }];
//https://raw.githubusercontent.com/jutewei/JuPlayVideo/master/JuMedia/test2.MP4
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
