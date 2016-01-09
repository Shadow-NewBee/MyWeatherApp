//
//  LSDaysWeatherCell.h
//  MyWeatherApp
//
//  Created by xiaoT on 16/1/8.
//  Copyright © 2016年 赖三聘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSDaysWeatherCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end
