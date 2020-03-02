//
//  AnswerSheetView.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/16.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnswerSheetView : UIView


/**
 初始化

 @param frame frame description
 @param type 0:选题   1:结果
 @param block block description
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type block:(XXIntegerBlock)block;

- (void)reload:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
