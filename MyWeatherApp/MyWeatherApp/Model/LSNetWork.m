//
//  LSNetWork.m
//  My weather app
//
//  Created by xiaoT on 15/12/27.
//  Copyright © 2015年 赖三聘. All rights reserved.
//  回调函数--请求网咯数据

#import "LSNetWork.h"
#import "AFNetworking.h"
@implementation LSNetWork

+(void)getDataWithParam:(NSDictionary *)param URL:(NSString *)url success:(void (^)(id))success fail:(void (^)(NSError *))fail
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [session GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
//            NSLog(@"--%@",responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

@end
