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
//天气基本信息
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, copy) NSString *date;
//风有关信息
@property (nonatomic, copy) NSString *windDirect;
@property (nonatomic, copy) NSString *windPower;
@property (nonatomic, copy) NSString *windSpeed;
//PM2.5
@property (nonatomic, copy) NSString *pm25;
@property (nonatomic, copy) NSString *quality;
@property (nonatomic, copy) NSString *des;


@end
