//
//  AnswerSheetView.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/16.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "AnswerSheetView.h"

@interface AnswerSheetView ()

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, copy) XXIntegerBlock block ;

@property (nonatomic, assign) NSInteger type;

@end

@implementation AnswerSheetView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type block:(XXIntegerBlock)block
{
    if (self = [super initWithFrame:frame])
    {
        if(block)
        {
            self.block = [block copy];
            
        }
        self.type = type;
        self.backgroundColor = kWhite;
    }
    return self;
}

- (void)setBtn:(UIButton *)btn tag:(NSString *)tag
{
    if (_type == 0) {
        btn.layer.borderColor = kBlue.CGColor;
        btn.layer.borderWidth = 1;
        if (kStrEqual(tag, @"1")) {
            btn.backgroundColor = kBlue;
            [btn setTitleColor:kWhite forState:UIControlStateNormal];
        }
        else
        {
            btn.backgroundColor = kWhite;
            [btn setTitleColor:kBlue forState:UIControlStateNormal];
        }
    }
    else
    {
        if (kStrEqual(tag, @"1")) {
            btn.backgroundColor = kBlue;
            [btn setTitleColor:kWhite forState:UIControlStateNormal];
        }
        else
        {
            btn.backgroundColor = kRed;
            [btn setTitleColor:kWhite forState:UIControlStateNormal];
        }
    }
    
    
}

- (void)reload:(NSArray *)data
{
    for (UIButton *btn in self.subviews) {
        [btn removeFromSuperview];
    }
    for (int i = 0; i < data.count; i++) {
        NSInteger x = i %5;
        NSInteger y = i/5;
        CGFloat width = kScale_W(25) ;
        CGFloat spacing_h = (kScreen_W - (width*5))/6;
        CGFloat spacing_v = kScale_W(25);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = kFrame((x+1)*spacing_h+ x*width, y*(spacing_v+width)+25, width, width);
        [btn setTitle:kStrNum(i+1) forState:UIControlStateNormal];
        btn.layer.cornerRadius = width/2;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setBtn:btn tag:data[i]];
        btn.tag = i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)click:(UIButton *)sender
{
    self.block(sender.tag);
}

@end
