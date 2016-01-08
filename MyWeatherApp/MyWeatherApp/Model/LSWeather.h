//
//  LSWeather.h
//  My weather app
//
//  Created by xiaoT on 15/12/27.
//  Copyright © 2015年 赖三聘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSWeather : NSObject

+(instancetype)weatherWithDic:(NSDictionary *)dic;

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, copy) NSString *date;

@end
