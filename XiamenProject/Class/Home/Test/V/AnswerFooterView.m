//
//  AnswerFooterView.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/14.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "AnswerFooterView.h"

@interface AnswerFooterView ()

@property (nonatomic, copy) XXIntegerBlock block ;

@end

@implementation AnswerFooterView

- (instancetype)initWithFrame:(CGRect)frame block:(XXIntegerBlock)block
{
    if (self = [super initWithFrame:frame])
    {
        if(block)
        {
            self.block = [block copy];
        }
        UIButton *btn = [[UIButton alloc]initWithFrame:kFrame(0, 0, kScreen_W, 45)];
        btn.backgroundColor = kBlue;
        [btn setTitle:@"交卷并查看结果" forState:UIControlStateNormal];
        btn.titleLabel.textColor = kWhite;
        btn.titleLabel.font = Font(16);
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)click
{
    self.block(0);
}


@end
