//
//  SQChooseCell.h
//  XiamenProject
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LawListModel.h"
#import "CompanyListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQChooseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;

- (void)setData:(NSString *)str;

- (void)setLawData:(LawListModel *)model;

- (void)setCompanyData:(CompanyModel *)model;

@end

NS_ASSUME_NONNULL_END
