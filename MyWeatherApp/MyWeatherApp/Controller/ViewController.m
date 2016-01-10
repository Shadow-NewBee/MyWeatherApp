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
#import "LSWeather.h"
#import "LSNetWork.h"
#import "LSFutureWeather.h"
#import "LSDaysWeatherCell.h"

@interface ViewController ()<CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) LSWeather *weather;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (nonatomic, strong) LSFutureWeather *futureWeather;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UICollectionView *myColletionView;

@property (nonatomic, strong) CLLocationManager *locationManager;

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
    cell.backgroundColor = [UIColor orangeColor];
    
    LSFutureWeather *futureWeather = self.futureWeather.dayWeather[indexPath.row];
    cell.weatherLabel.text = [self.futureWeather.dayWeather[indexPath.row] weather];
    cell.weekLabel.text = futureWeather.week;
    cell.tempLabel.text = futureWeather.temperature;
    
    
    return cell;
}



- (IBAction)searchWeather:(id)sender {
    NSString *cityStr = self.cityTextField.text;

    [self getWeatherWithCityStr:cityStr];
    [self.cityTextField resignFirstResponder];
    
}

- (IBAction)locationClicked {
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始定位");
//        设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
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
//            获取定位城市名称
            CLPlacemark *placeMark = [placemarks objectAtIndexedSubscript:0];
            NSString *cityStr = placeMark.locality;
            [self getWeatherWithCityStr:cityStr];
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
        NSDictionary *valueDic = responseDic[@"result"];
        NSDictionary *dataDic = valueDic[@"data"];
        //      今天的天气信息dic,并设置今天的天气信息
        NSDictionary *todayWeatherDic = dataDic[@"realtime"];
        LSWeather *todayWeather = [LSWeather weatherWithDic:todayWeatherDic];
        
        self.cityLabel.text = todayWeather.city;
        self.tempLabel.text = [NSString stringWithFormat:@"%@°",todayWeather.temp];
        self.weatherLabel.text = todayWeather.weather;

        //       未来几天天气
        LSFutureWeather *futureWeather = [LSFutureWeather futherWeatherWithDic:dataDic];
        //      作为后面的collectionView做数据源
        self.futureWeather = futureWeather;
//        NSLog(@"futureWeather.week---%@",futureWeather.week);
        [self.myColletionView reloadData];
    } fail:^(NSError *error) {
        NSString *errorStr = [NSString stringWithFormat:@"%@",error];
        [self recieveAlertAlertTitle:@"Net Error" alertMessage:errorStr];
    }];

}


@end
