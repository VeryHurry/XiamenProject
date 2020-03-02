//
//  ResultFooterView.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/16.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "ResultFooterView.h"

@interface ResultFooterView ()

@property (nonatomic, copy) XXIntegerBlock block1;

@property (nonatomic, copy) XXIntegerBlock block2;

@end

@implementation ResultFooterView

- (instancetype)initWithFrame:(CGRect)frame block1:(XXIntegerBlock)block1 block2:(XXIntegerBlock)block2
{
    if (self = [super initWithFrame:frame])
    {
        if(block1)
        {
            self.block1 = [block1 copy];
        }
        if(block2)
        {
            self.block2 = [block2 copy];
        }
        self.backgroundColor = kWhite;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIButton *btn1 = [[UIButton alloc]initWithFrame:kFrame(0, 0, kScreen_W/2, 45)];
    btn1.backgroundColor = kBlue;
    [btn1 setTitle:@"重新测试" forState:UIControlStateNormal];
    btn1.titleLabel.textColor = kWhite;
    btn1.titleLabel.font = Font(15);
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:kFrame(kScreen_W/2, 0, kScreen_W/2, 45)];
    btn2.backgroundColor = kBlue;
    [btn2 setTitle:@"继续学习" forState:UIControlStateNormal];
    btn2.titleLabel.textColor = kWhite;
    btn2.titleLabel.font = Font(15);
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:kFrame(kScreen_W/2-0.5, 0, 1, 45)];
    lbl.backgroundColor = kWhite;
    [self addSubview:lbl];
}

- (void)click:(UIButton *)sender
{
    if (sender.tag == 1) {
        self.block1(0);
    }
    else
    {
        self.block2(0);
    }
}

@end
