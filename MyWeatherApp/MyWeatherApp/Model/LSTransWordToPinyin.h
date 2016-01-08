//
//  LSTransWordToPinyin.h
//  My weather app
//
//  Created by xiaoT on 15/12/31.
//  Copyright © 2015年 赖三聘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSTransWordToPinyin : NSObject

+(void)transToPinyinWithString:(NSString *)word returnThePinyin:(void(^)(NSString* pinyin))pinyin;
@end
