//
//  GoTestView.h
//  VehicleManagement
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 ZB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoTestView : UIView

@property(nonatomic, copy) XXVoidBlock block;
@property(nonatomic, copy) XXVoidBlock closeBlock;

+ (void)alertWithBlock:(XXVoidBlock)block closeBlock:(XXVoidBlock)closeBlock;

@end

NS_ASSUME_NONNULL_END
