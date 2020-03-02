//
//  SQChooseView.h
//  XiamenProject
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQChooseView : UIView


- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock;

@end

NS_ASSUME_NONNULL_END
