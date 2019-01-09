//
//  SHHTTPRequest.h
//  SHBaseProject
//
//  Created by Juvid on 16/1/19.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JuHTTPRequest : NSObject<NSURLSessionTaskDelegate>
+ (JuHTTPRequest *)sharedInstance;

-(void)juPostPath:(NSString *)url
      parameters:(NSDictionary *)parameters
         success:(void(^)(NSDictionary *json))processResult
       failblock:(void(^)(NSError *error))failresult;

-(void)juDownRequest:(NSString *)url
          parameters:(NSDictionary *)parameters
             success:(void(^)(NSDictionary *json))processResult
           failblock:(void(^)(NSError *error))failresult;

-(void)juDownURL:(NSString *)url
         success:(void(^)(NSString *locationUrl))processResult
       failblock:(void(^)(NSError *error))failresult;
@end
