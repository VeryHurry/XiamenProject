//
//  GoTestView.m
//  VehicleManagement
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 ZB. All rights reserved.
//

#import "GoTestView.h"

@interface GoTestView ()

@end

@implementation GoTestView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

+ (void)alertWithBlock:(XXVoidBlock)block closeBlock:(XXVoidBlock)closeBlock
{
    
    GoTestView * alertView = [[NSBundle mainBundle] loadNibNamed:@"GoTestView" owner:nil options:nil].firstObject;
    
    alertView.frame = CGRectMake(0, 0, 265, 332+75);
    
    alertView.block = block;
    alertView.closeBlock = closeBlock;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alertView.layer addAnimation:animation forKey:nil];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    alertView.center = keyWindow.center;
    [keyWindow addSubview:alertView];
    
}

- (IBAction)gotoTest:(id)sender {
    if (self.block) {
        self.block();
    }
    [self removeFromSuperview];
    
}

- (IBAction)close:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
    [self removeFromSuperview];
}

@end
