//
//  ViewController.m
//  My weather app
//
//  Created by xiaoT on 15/12/26.
//  Copyright © 2015年 赖三聘. All rights reserved.
//http://op.juhe.cn/onebox/weather/query

#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "LSWeather.h"
#import "LSNetWork.h"
#import "LSFutureWeather.h"
#import "LSDaysWeatherCell.h"

@interface ViewController ()<CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>
@property (nonatomic, strong) LSWeather *weather;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectLabel;
@property (weak, nonatomic) IBOutlet UILabel *windPowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *pm25Label;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myContainView;
@property (strong, nonatomic) IBOutlet UICollectionView *myColletionView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) LSFutureWeather *futureWeather;

- (IBAction)searchWeather:(id)sender;
- (IBAction)locationClicked;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityTextField.keyboardType = UIKeyboardTypeDefault;
//    设置collectionView
    self.myColletionView.delegate = self;
    self.myColletionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.myColletionView.collectionViewLayout = flowLayout;
    UINib *nib = [UINib nibWithNibName:@"LSDaysWeatherCell" bundle:[NSBundle mainBundle]];
    [self.myColletionView registerNib:nib forCellWithReuseIdentifier:@"weatherCell"];
    self.myColletionView.showsHorizontalScrollIndicator = NO;
//    设置背景图片
    self.myColletionView.backgroundColor =[UIColor clearColor];
    self.myScrollView.backgroundColor = [UIColor clearColor];
    self.myContainView.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self locationClicked];
}


#pragma mark----CollectionViewDelegate &dataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.futureWeather.dayWeather.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedId = @"weatherCell";
    LSDaysWeatherCell *cell = (LSDaysWeatherCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reusedId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    LSFutureWeather *futureWeather = self.futureWeather.dayWeather[indexPath.row];
    cell.weatherLabel.text = [self.futureWeather.dayWeather[indexPath.row] weather];
    cell.weekLabel.text = [NSString stringWithFormat:@"星期%@",futureWeather.week];
    cell.tempLabel.text = [NSString stringWithFormat:@"%@°",futureWeather.temperature];

    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)searchWeather:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *cityStr = self.cityTextField.text;
    if (cityStr.length) {
        [self getWeatherWithCityStr:cityStr];
        [self.cityTextField resignFirstResponder];
    } else {
        [self recieveAlertAlertTitle:@"No City Name" alertMessage:@"Please type in city name!"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

- (IBAction)locationClicked {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
    
    if ([CLLocationManager locationServicesEnabled]) {
//        设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100;
        
        [self.locationManager startUpdatingLocation];
    } else {
        [self recieveAlertAlertTitle:@"ERROR" alertMessage:@"Can not locate!"];
    }
    self.cityTextField.text = nil;
    [self.cityTextField resignFirstResponder];
}

#pragma -mark locationDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
//            获取定位城市名称
            CLPlacemark *placeMark = [placemarks objectAtIndexedSubscript:0];
            NSString *cityStr = placeMark.locality;
            [self getWeatherWithCityStr:cityStr];
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self recieveAlertAlertTitle:@"Location Fail" alertMessage:@"Can not locate"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_locationManager stopUpdatingLocation];
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

-(void)getWeatherWithCityStr:(NSString *)cityStr
{
    NSString *urlStr = @"http://op.juhe.cn/onebox/weather/query";
    //   param
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cityname"] = cityStr;
    param[@"key"] = @"74a29f7f1c249e5926f52311458f5d78";
    
    [LSNetWork getDataWithParam:param URL:urlStr success:^(id responseDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *valueDic = responseDic[@"result"];
        NSDictionary *dataDic = valueDic[@"data"];
        //      今天的天气信息dic,并设置今天的天气信息
        LSWeather *todayWeather = [LSWeather weatherWithDic:dataDic];
        
        self.cityLabel.text = todayWeather.city;
        self.tempLabel.text = [NSString stringWithFormat:@"%@°",todayWeather.temp];
        self.weatherLabel.text = todayWeather.weather;
        self.windDirectLabel.text = [NSString stringWithFormat:@"风向 : %@",todayWeather.windDirect];
        self.windPowerLabel.text = [NSString stringWithFormat:@"级数 : %@",todayWeather.windPower];
        self.windSpeedLabel.text = [NSString stringWithFormat:@"风速 : %@m/min",todayWeather.windSpeed];
//        PM2.5
        self.pm25Label.text = [NSString stringWithFormat:@"PM2.5 : %@",todayWeather.pm25];
        self.qualityLabel.text = [NSString stringWithFormat:@"Quality : %@",todayWeather.quality];
        self.desLabel.text = [NSString stringWithFormat:@"%@",todayWeather.des];
        UIImage *weatherImage = [UIImage imageNamed:todayWeather.weather];
        if (weatherImage) {
            self.view.backgroundColor = [UIColor colorWithPatternImage:weatherImage];
        } else {
            self.view.backgroundColor = [UIColor whiteColor];
        }
        
        //      未来几天天气
        LSFutureWeather *futureWeather = [LSFutureWeather futherWeatherWithDic:dataDic];

        self.futureWeather = futureWeather;

        [self.myColletionView reloadData];
    } fail:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"%@",error];
        [self recieveAlertAlertTitle:@"Net Error" alertMessage:errorStr];
    }];

}


@end
