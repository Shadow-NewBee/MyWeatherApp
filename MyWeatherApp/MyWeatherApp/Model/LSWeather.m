//
//  LSWeather.m
//  My weather app
//
//  Created by xiaoT on 15/12/27.
//  Copyright © 2015年 赖三聘. All rights reserved.
//

#import "LSWeather.h"

@implementation LSWeather

+(instancetype)weatherWithDic:(NSDictionary *)dic
{
    LSWeather *weather = [[LSWeather alloc] init];

    weather.city = dic[@"city"];
    weather.temp = dic[@"temp"];
    weather.date = dic[@"date"];
    weather.weather = dic[@"weather"];

    return weather;
}
@end
