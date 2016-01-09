//
//  LSFutureWeather.h
//  MyWeatherApp
//
//  Created by xiaoT on 16/1/8.
//  Copyright © 2016年 赖三聘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSFutureWeather : NSObject

//白天天气的array,对应dic中key:info-day
@property (nonatomic, strong) NSArray *dayWeather;
//其均包含在array中
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *temperature;
//对应dic中的key:week
@property (nonatomic, copy) NSString *week;

+(instancetype)futherWeatherWithDic:(NSDictionary *)dic;
@end
