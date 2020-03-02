//
//  ResultFooterView.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/16.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultFooterView : UIView

- (instancetype)initWithFrame:(CGRect)frame block1:(XXIntegerBlock)block1 block2:(XXIntegerBlock)block2;

@end

NS_ASSUME_NONNULL_END
