//
//  AnswerHeaderView.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/14.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnswerHeaderView : UIView

@property (nonatomic,strong) AnswerDetailModel *model;

@property (nonatomic, assign) CGFloat headerHeight;

@end

NS_ASSUME_NONNULL_END
