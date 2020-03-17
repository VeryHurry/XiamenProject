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

//type 0:单选  1:多选 2:没有模型
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type title:(NSString *)title data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock;

@end

NS_ASSUME_NONNULL_END
