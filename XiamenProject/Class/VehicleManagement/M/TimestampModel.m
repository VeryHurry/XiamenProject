//
//  TimestampModel.m
//  MTTWallet
//
//  Created by mtt on 2017/4/5.
//  Copyright © 2017年 mtt. All rights reserved.
//

#import "TimestampModel.h"

@implementation TimestampModel


+(NSString *)getTimeWithTimestamp:(NSString *)timestamp
{
    NSUInteger timeS=[timestamp doubleValue] /1000;
    
    NSTimeInterval time=timeS;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    
    return currentDateStr;
}


+(NSString *)getLocationTime:(NSString *)timestamp
{
    
    NSUInteger timeS=[timestamp doubleValue] /1000;
    
    NSTimeInterval time=timeS;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    
    return currentDateStr;
    
}

#pragma mark - 获取包含年份的日期
+(NSString *)getHistoryTime:(NSString *)timestamp
{
    
    NSUInteger timeS=[timestamp doubleValue] /1000;
    
    NSTimeInterval time=timeS;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    
    return currentDateStr;
}


+(NSString *)getWarnningTime:(NSString *)timestamp
{
    
    NSUInteger timeS=[timestamp doubleValue]/1000;
    
    NSTimeInterval time=timeS;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd\nHH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    
    return currentDateStr;
    
}

@end
