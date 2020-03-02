//
//  CircleView.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircleProgress.h"
#import "XLCircle.h"

@implementation XLCircleProgress
{
    XLCircle* _circle;
    UILabel *_percentLabel;
}

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth startColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _percentLabel.textColor = [UIColor whiteColor];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel.font = [UIFont boldSystemFontOfSize:50];
        _percentLabel.text = @"0%";
        [self addSubview:_percentLabel];
        
        _circle = [[XLCircle alloc] initWithFrame:self.bounds lineWidth:lineWidth startColor:startColor endColor:endColor];
        [self addSubview:_circle];
    }
    return self;
}


#pragma mark -
#pragma mark Setter方法
-(void)setProgress:(float)progress
{
    _progress = progress;
    _circle.progress = progress;
    _percentLabel.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
}

@end
