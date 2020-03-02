//
//  SQRegistMessageViewController.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/9.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQRegistMessageViewController : BaseViewController

@property (nonatomic, copy) NSString *phoneStr, *codeStr, *passwordStr;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UserModel *model;

@end

NS_ASSUME_NONNULL_END
