//
//  ViewController.m
//  My weather app
//
//  Created by xiaoT on 15/12/26.
//  Copyright © 2015年 赖三聘. All rights reserved.
//http://apistore.baidu.com/astore/serviceinfo/1798.html

#import "ViewController.h"
#import "AFNetworking.h"
#import "LSWeather.h"
#import "LSNetWork.h"
#import "LSTransWordToPinyin.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) LSWeather *weather;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (nonatomic, strong) CLLocationManager *locationManager;

- (IBAction)searchWeather:(id)sender;
- (IBAction)locationClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityTextField.keyboardType = UIKeyboardTypeDefault;
}

-(void)getWeatherWithCityStr:(NSString *)cityStr
{
    
    NSString *urlStr = @"http://apistore.baidu.com/microservice/weather";
    //   param
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"citypinyin"] = cityStr;
    
    [LSNetWork getDataWithParam:param URL:urlStr success:^(id responseDic) {
        NSDictionary *valueDic = responseDic[@"retData"];
        if ([valueDic count] != 0) {
            LSWeather *weather = [LSWeather weatherWithDic:valueDic];
            self.tempLabel.text = [NSString stringWithFormat:@"%@ ℃",weather.temp];
            self.cityLabel.text = weather.city;
            self.dateLabel.text = weather.date;
            self.weatherLabel.text = weather.weather;
        } else {
            NSString *alertTitle = @"Incorrect City Name";
            NSString *alertMessage = @"Please check the city name.";
            
            [self recieveAlertAlertTitle:alertTitle alertMessage:alertMessage];
        }
        
    } fail:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"%@",error];
        [self recieveAlertAlertTitle:@"Net Error" alertMessage:errorStr];
    }];
}

-(void)recieveAlertAlertTitle:(NSString *)alertTitle alertMessage:(NSString *)alertMessage
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancelAction];
    [alertVc addAction:okAction];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (IBAction)searchWeather:(id)sender {
    __block NSString *cityStr = self.cityTextField.text;

    if ([cityStr length]) {
        
        [LSTransWordToPinyin transToPinyinWithString:cityStr returnThePinyin:^(NSString *pinyin) {
            cityStr = pinyin;
        }];

    }
    [self getWeatherWithCityStr:cityStr];
    [self.cityTextField resignFirstResponder];
    
}

- (IBAction)locationClicked:(id)sender {
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始定位");
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 100;
        
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"定位失败");
    }
    [self.cityTextField resignFirstResponder];
}

#pragma -mark locationDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndexedSubscript:0];
            //               通过反向编码获取当前定位城市名称
            __block NSString *cityStr = placeMark.locality;
            //               取特定字符前的字符串
            if ([cityStr rangeOfString:@"市"].location != NSNotFound) {
                NSRange range = [cityStr rangeOfString:@"市"];
                __block  NSString *str = [cityStr substringToIndex:range.location];
 //                根据获取的城市名进行天气搜索
                [LSTransWordToPinyin transToPinyinWithString:str returnThePinyin:^(NSString *pinyin) {
                    str = pinyin;
                }];
                [self getWeatherWithCityStr:str];
            } else {
                if ([cityStr length]) {
                    [LSTransWordToPinyin transToPinyinWithString:cityStr returnThePinyin:^(NSString *pinyin) {
                        cityStr = pinyin;
                    }];
                    [self getWeatherWithCityStr:cityStr];
                }
            }
            
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_locationManager stopUpdatingLocation];
}

@end
