//
//  UIColor+Hex.m
//  ColorDemo
//
//  Created by mac on 16/12/21.
//  Copyright © 2016年 Xp. All rights reserved.
//

#import "UIColor+Hex.h"
#define CLEAR_COLOR [UIColor clearColor]
@implementation UIColor (Hex)

+(UIColor *)colorWithHexStr:(NSString *)str
{
    str = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]uppercaseString];
    
    if (str.length<6)
    {
        return CLEAR_COLOR;
    }
    
    if ([str hasPrefix:@"#"])
    {
        str = [str substringFromIndex:1];
    }
    
    if ([str hasPrefix:@"0X"])
    {
        str = [str substringFromIndex:2];
    }
    
    if (str.length!=6)
    {
        return CLEAR_COLOR;
    }
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"];
    
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:str];
    
    if (![set isSupersetOfSet:cSet])
    {
        return CLEAR_COLOR;
    }
    
    NSRange range;
    
    range.location = 0;
    range.length = 2;
    
    NSString *rStr = [str substringWithRange:range];
    
    range.location = 2;
    NSString *gStr = [str substringWithRange:range];
    
    range.location = 4;
    NSString *bStr = [str substringWithRange:range];
    
    unsigned int r,g,b;
    
//    扫描字符串，并把字符串代表的十六进制值
    [[NSScanner scannerWithString:rStr]scanHexInt:&r];
    [[NSScanner scannerWithString:gStr]scanHexInt:&g];
    [[NSScanner scannerWithString:bStr]scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    
}

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-16, 66);
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexStr:fromHexColorStr].CGColor,(__bridge id)[UIColor colorWithHexStr:toHexColorStr].CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}



@end
