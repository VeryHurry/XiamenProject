//
//  SQViolationsCell.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/21.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViolationsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQViolationsCell : UITableViewCell

- (void)setData:(ViolationsListModel *)model;

@end

NS_ASSUME_NONNULL_END
