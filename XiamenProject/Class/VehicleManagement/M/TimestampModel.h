//
//  TimestampModel.h
//  MTTWallet
//
//  Created by mtt on 2017/4/5.
//  Copyright © 2017年 mtt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimestampModel : NSObject

+(NSString *)getTimeWithTimestamp:(NSString *)timestamp;

+(NSString *)getLocationTime:(NSString *)timestamp;

+(NSString *)getHistoryTime:(NSString *)timestamp;

+(NSString *)getWarnningTime:(NSString *)timestamp;

@end
