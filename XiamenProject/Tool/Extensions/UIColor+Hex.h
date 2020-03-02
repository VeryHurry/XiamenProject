//
//  UIColor+Hex.h
//  ColorDemo
//
//  Created by mac on 16/12/21.
//  Copyright © 2016年 Xp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexStr:(NSString *)str;

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
@end
