//
//  NSString+Date.m
//  TTSDemo
//
//  Created by Fengur on 16/9/23.
//  Copyright © 2016年 code.sogou.fengur. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSString *)fg_stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

@end
