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
    NSDictionary *todayWeatherDic = dic[@"realtime"];
    weather.city = todayWeatherDic[@"city_name"];
//    info & temp
    NSDictionary *weatherDic = todayWeatherDic[@"weather"];
    weather.temp = weatherDic[@"temperature"];
    weather.weather = weatherDic[@"info"];
//    windInfo
    NSDictionary *windDic = todayWeatherDic[@"wind"];
    weather.windDirect = windDic[@"direct"];
    weather.windPower = windDic[@"power"];
    weather.windSpeed = windDic[@"windspeed"];
//    pm2.5 Info
    NSDictionary *pmDic = dic[@"pm25"];
    NSDictionary *detailPmDic = pmDic[@"pm25"];
    weather.pm25 = detailPmDic[@"pm25"];
    weather.quality = detailPmDic[@"quality"];
    weather.des = detailPmDic[@"des"];
    
    
    return weather;
}
@end
