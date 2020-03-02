//
//  HeadTitleView.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/21.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeadTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXIntegerBlock)block;

@end

NS_ASSUME_NONNULL_END
