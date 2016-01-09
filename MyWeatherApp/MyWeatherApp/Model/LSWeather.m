//
//  LSWeather.m
//  My weather app
//
//  Created by xiaoT on 15/12/27.
//  Copyright © 2015年 赖三聘. All rights reserved.
//{
//"city_code" = 101210101;
//"city_name" = "\U676d\U5dde";
//dataUptime = 1452234423;
//date = "2016-01-08";
//moon = "\U5341\U4e00\U6708\U5eff\U4e5d";
//time = "14:00:00";
//weather =     {
//    humidity = 64;
//    img = 1;
//    info = "\U591a\U4e91";
//    temperature = 6;
//};
//week = 5;
//wind =     {
//    direct = "\U5317\U98ce";
//    offset = "<null>";
//    power = "2\U7ea7";
//    windspeed = "11.0";
//};
#import "LSWeather.h"

@implementation LSWeather

+(instancetype)weatherWithDic:(NSDictionary *)dic
{
    LSWeather *weather = [[LSWeather alloc] init];
//  cityName
    weather.city = dic[@"city_name"];
//    info & temp
    NSDictionary *weatherDic = dic[@"weather"];
    weather.temp = weatherDic[@"temperature"];
    weather.weather = weatherDic[@"info"];

    return weather;
}
@end
