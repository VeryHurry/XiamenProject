//
//  SQTrackMessageView.m
//  XiamenProject
//
//  Created by mac on 2019/7/8.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQTrackMessageView.h"
#import "MacroDefinition.h"

@interface SQTrackMessageView ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *trackNo;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation SQTrackMessageView

- (instancetype)initWithFrame:(CGRect)frame model:(trackModel *)model
{
    self = [super initWithFrame:kFrame(0, 200, frame.size.width, frame.size.height)];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SQTrackMessageView class]) owner:self options:nil] firstObject];
    }
    self.trackNo.text = model.trackNo;
    self.startTime.text = model.startTime;
    self.endTime.text = model.endTime;
    self.startAddress.text = model.startAdress;
    self.endAddress.text = model.endAdress;
    self.total.text = kStrNum(model.mileage);
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    WeakSelf(ws);
    [_topView xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        ws.isShow = !ws.isShow;
        [ws trackViewShow:ws.isShow];
    }];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self addGestureRecognizer:recognizer];

    self.frame = kFrame(0, kScreen_H-35, kScreen_W, 275);
}

- (void)trackViewShow:(BOOL)isShow
{
    if (isShow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = kFrame(0, kScreen_H-275, kScreen_W, 275);
        }];
        
        self.img.image= [UIImage imageNamed:@"ic_down"];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = kFrame(0, kScreen_H-35, kScreen_W, 275);
        }];
        self.img.image= [UIImage imageNamed:@"ic_up"];
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionDown)
    {
        self.isShow = !self.isShow;
        [self trackViewShow:NO];
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionUp)
    {
        self.isShow = !self.isShow;
        [self trackViewShow:YES];
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionLeft)
    {
      
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionRight)
    {
        
    }
}


@end
