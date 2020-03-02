//
//  SQTestListCell.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/13.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQTestListCell : UITableViewCell

- (void)setData:(SQTestModel *)model;

@end

NS_ASSUME_NONNULL_END
