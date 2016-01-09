//
//  LSNetWork.h
//  My weather app
//
//  Created by xiaoT on 15/12/27.
//  Copyright © 2015年 赖三聘. All rights reserved.
//  回调函数--请求网咯数据

#import <Foundation/Foundation.h>



@interface LSNetWork : NSObject

+(void)getDataWithParam:(NSDictionary *)param URL:(NSString *)url success:(void (^)(id responseDic))success fail:(void (^)(NSError *error))fail;

@end
