//
//  LSFutureWeather.m
//  MyWeatherApp
//
//  Created by xiaoT on 16/1/8.
//  Copyright © 2016年 赖三聘. All rights reserved.
//

#import "LSFutureWeather.h"

@implementation LSFutureWeather

+(instancetype)futherWeatherWithDic:(NSDictionary *)dic
{
    LSFutureWeather *futureWeather = [[LSFutureWeather alloc]init];
//   这个tempDic包含day和night的天气(均是array)
    NSArray *weatherArray = dic[@"weather"];
    NSMutableArray *temArray = [NSMutableArray array];
    for (NSDictionary *dic in weatherArray) {
        NSDictionary *detailDayDic = dic[@"info"];
        NSArray *dayW = detailDayDic[@"day"];
        LSFutureWeather *insideWeather = [[LSFutureWeather alloc]init];
        insideWeather.weather = dayW[1];
        insideWeather.temperature = dayW[2];
        insideWeather.week = dic[@"week"];
        [temArray addObject:insideWeather];
    }
    futureWeather.dayWeather = temArray;
    
    return futureWeather;
}



@end
