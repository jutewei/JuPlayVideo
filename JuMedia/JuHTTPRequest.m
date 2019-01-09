//
//  SHHTTPRequest.m
//  SHBaseProject
//
//  Created by Juvid on 16/1/19.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuHTTPRequest.h"

@implementation JuHTTPRequest
+ (JuHTTPRequest *)sharedInstance{
    static JuHTTPRequest *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(void)juPostPath:(NSString *)url
      parameters:(NSDictionary *)parameters
         success:(void(^)(NSDictionary *json))processResult
       failblock:(void(^)(NSError *error))failresult{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSString* postURL=url;
        if (parameters) {
            postURL=[NSString stringWithFormat:@"%@?%@",url,[self getParameters:parameters]];
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postURL]];
        request.timeoutInterval=30;
        request.HTTPMethod=@"GET";
        NSURLSessionDataTask *task= [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if ([data length] > 0 && error == nil){
                NSError *error1=nil;
                NSDictionary *Result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                processResult(Result);
            }
            else{
                failresult(error);
            }
        }];
        [task resume];
       /* NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&response2 error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([response length] > 0 && error == nil){
                NSError *error1=nil;
                NSDictionary *Result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error1];
                processResult(Result);
            }
            else{
                failresult(error);
            }
        });*/
        
    });

}
-(void)juDownRequest:(NSString *)url
       parameters:(NSDictionary *)parameters
          success:(void(^)(NSDictionary *json))processResult
        failblock:(void(^)(NSError *error))failresult{
    NSString* postURL=url;
    if (parameters) {
        postURL=[NSString stringWithFormat:@"%@?%@",url,[self getParameters:parameters]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postURL]];
    request.timeoutInterval=30;
    request.HTTPMethod=@"GET";
    NSURLSessionDataTask *task= [[NSURLSession sharedSession]downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",location);
    }];

    [task resume];
}

-(void)juDownURL:(NSString *)url
         success:(void(^)(NSString *locationUrl))processResult
       failblock:(void(^)(NSError *error))failresult{
    
    NSString *fileName=[url lastPathComponent];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        processResult(path);
        return;
    }

    NSURLSessionDownloadTask *task=[[NSURLSession sharedSession]downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 复制文件
        [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:path error:NULL];
        processResult(path);
    }];
    [task resume];
}

-(void)juTest{
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];

    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //3.创建会话对象,设置代理
    /*
     第一个参数:配置信息 [NSURLSessionConfiguration defaultSessionConfiguration]
     第二个参数:代理
     第三个参数:设置代理方法在哪个线程中调用
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    //4.创建Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];

    //5.执行Task
    [dataTask resume];

}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    ;
}



-(NSString *)getParameters:(NSDictionary *)dicParametes{
    NSMutableArray *mutablePairs=[NSMutableArray array];
    for (NSString *keys in dicParametes) {
        [mutablePairs addObject:[NSString stringWithFormat:@"%@=%@",keys,dicParametes[keys]]];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}
@end
