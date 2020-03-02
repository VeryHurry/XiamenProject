//
//  AnswerOptionTableViewCell.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/13.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnswerOptionTableViewCell : UITableViewCell

@property (nonatomic,strong) optionsList *model;

- (void)setModel:(optionsList *)model;

@end

NS_ASSUME_NONNULL_END
