//
//  HeadTitleView.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/21.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "HeadTitleView.h"

@interface HeadTitleView ()

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, copy) XXIntegerBlock block ;

@end

@implementation HeadTitleView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXIntegerBlock)block
{
    if (self = [super initWithFrame:frame])
    {
        if(block)
        {
            self.block = [block copy];
        }
        self.titleArr = data;
        [self initTitleView];
    }
    return self;
}

-(void)initTitleView
{
    
    
    CGFloat width = 0;
    for (int i = 0; i < self.titleArr.count; i ++) {
        CGRect rect = [self.titleArr[i] boundingRectWithSize:CGSizeMake(100, 25) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : Font(18)} context:nil];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width*i+28*i, 0, rect.size.width, 25);
        
        btn.tag = i;
        btn.titleLabel.font = Font(18);
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [self setBtnStyle:btn tag:0];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        width = rect.size.width + width;
        self.frame = CGRectMake(0, 0, width+28, 25);
    }
}

#pragma mark - action
- (void)btnAction:(UIButton *)sender
{
    for (UIButton *btn in self.subviews) {
        [self setBtnStyle:btn tag:sender.tag];
    }
    
    if (sender.tag == 0) {
        self.block(2);
    }
    else
    {
        self.block(1);
    }
}

- (void)setBtnStyle:(UIButton *)btn tag:(NSInteger)tag
{
    if (btn.tag == tag) {
        [btn setTitleColor:kBlue forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitleColor:kGray forState:UIControlStateNormal];
    }
}



@end
