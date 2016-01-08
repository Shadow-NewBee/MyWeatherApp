//
//  LSTransWordToPinyin.m
//  My weather app
//
//  Created by xiaoT on 15/12/31.
//  Copyright © 2015年 赖三聘. All rights reserved.
//

#import "LSTransWordToPinyin.h"

@implementation LSTransWordToPinyin

+(void)transToPinyinWithString:(NSString *)word returnThePinyin:(void(^)(NSString* pinyin))pinyin
{
     NSMutableString *cityPinyin = [[NSMutableString alloc] initWithString:word];
    if (CFStringTransform((__bridge CFMutableStringRef)cityPinyin, 0, kCFStringTransformMandarinLatin, NO)) {
    }
    if (CFStringTransform((__bridge CFMutableStringRef)cityPinyin, 0, kCFStringTransformStripDiacritics, NO)) {
    }
     NSString *finalCityName = [cityPinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
    pinyin(finalCityName);
}

@end
