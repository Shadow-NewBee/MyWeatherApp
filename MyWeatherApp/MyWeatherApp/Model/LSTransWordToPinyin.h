//
//  LSTransWordToPinyin.h
//  My weather app
//
//  Created by xiaoT on 15/12/31.
//  Copyright © 2015年 赖三聘. All rights reserved.
//  这个是用来将汉字转成拼音用的（有的api需要的请求参数中，需要城市名的拼音）

#import <Foundation/Foundation.h>

@interface LSTransWordToPinyin : NSObject

+(void)transToPinyinWithString:(NSString *)word returnThePinyin:(void(^)(NSString* pinyin))pinyin;
@end
