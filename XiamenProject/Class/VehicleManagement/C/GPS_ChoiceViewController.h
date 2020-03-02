//
//  GPS_ChoiceViewController.h
//  LeTu
//
//  Created by mtt on 2018/1/8.
//  Copyright © 2018年 mtt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPS_ChoiceViewController : UIViewController

@property (nonatomic,copy)void (^pathBlock)(NSInteger index,NSString *startTime,NSString *endTime);

@property (nonatomic,copy)NSString *vehicleNo;

@end
