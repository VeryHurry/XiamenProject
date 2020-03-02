//
//  SQTestResultViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/16.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQTestResultViewController.h"
#import "SQTestHeadViewController.h"
#import "SQTestListViewController.h"
#import "MacroDefinition.h"
#import "XLCircleProgress.h"
#import "AnswerSheetView.h"
#import "ResultFooterView.h"

@interface SQTestResultViewController ()
{
    XLCircleProgress *_circle;
}

@property (strong, nonatomic) UILabel *scoreLbl;

@property (nonatomic, strong) AnswerSheetView *sheetView;

@property (nonatomic, strong) ResultFooterView *footerView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SQTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhite;
    self.isBack = YES;
    
    UIButton  * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 50, 44)];
    [customBtn setTitle:@"首页" forState:UIControlStateNormal];
    customBtn.titleLabel.font = Font(13);
    customBtn.titleLabel.textAlignment = 2;
    [customBtn setTitleColor:ColorWithHex(0x959595) forState:UIControlStateNormal];
    customBtn.enabled = NO;
    customBtn.tag = 1;
    [customBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    [self createProgreeView];
    [self.view addSubview:self.sheetView];
    [self.sheetView reload:_resultDic[@"rights"]];

    [self.view addSubview:self.footerView];
}
     
- (void)backHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
         

- (void)createProgreeView
{
//    _progressView = [[CATCurveProgressView alloc]initWithFrame:kFrame((kScreen_W-kScale_W(140))/2, 50+kNav_H, kScale_W(140), kScale_W(140))];
//    _progressView.enableGradient = YES;
//    _progressView.curveBgColor = kWhite;
//    _progressView.progressLineWidth = kScale_W(9);
//    _progressView.startAngle = -90;
//    _progressView.endAngle = 270;
//    _progressView.gradientLayer2.colors = [NSArray arrayWithObjects:(id)ColorWithHex(0x0024FF).CGColor,(id)ColorWithHex(0x00A0E9).CGColor,nil];
//    _progressView.gradientLayer1.colors = [NSArray arrayWithObjects:(id)ColorWithHex(0x00A0E9).CGColor,ColorWithHex(0x0024FF).CGColor,nil];
//    [self.view addSubview:_progressView];
    
    _circle = [[XLCircleProgress alloc] initWithFrame:kFrame((kScreen_W-kScale_W(140))/2, 50+kNav_H, kScale_W(140), kScale_W(140)) lineWidth:kScale_W(9) startColor:[UIColor colorWithRed:0/255.0 green:36/255.0 blue:255/255.0 alpha:1] endColor:[UIColor colorWithRed:0/255.0 green:160/255.0 blue:233/255.0 alpha:1]];
    CGFloat score = [_resultDic[@"result"] floatValue];
    _circle.progress = score/100.0;
    _circle.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_circle];
    
    UIView *bgView = [[UIView alloc]initWithFrame:kFrame(0, 0, (kScreen_W-kScale_W(140))/2-15, (kScreen_W-kScale_W(140))/2-15)];
    bgView.center = _circle.center;
    bgView.backgroundColor = kWhite;
    bgView.layer.cornerRadius = ((kScreen_W-kScale_W(140))/2-10)/2;
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,-3);
    bgView.layer.shadowOpacity = 1;
    bgView.layer.shadowRadius = 3;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    
    _scoreLbl = [[UILabel alloc]init];
    _scoreLbl.frame = kFrame(0, 0, (kScreen_W-kScale_W(140))/2-10, 60);
    _scoreLbl.center = CGPointMake(_circle.center.x, _circle.center.y-10);
    _scoreLbl.text = [NSString stringWithFormat:@"%@",_resultDic[@"result"]];
    _scoreLbl.textAlignment = 1;
    _scoreLbl.textColor = kBlack;
    _scoreLbl.font = Font(52);
    [self.view addSubview:_scoreLbl];
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.frame = kFrame(0, 0, (kScreen_W-kScale_W(140))/2-10, 15);
    lbl.center = CGPointMake(_circle.center.x, _circle.center.y+30);
    lbl.text = @"分";
    lbl.textAlignment = 1;
    lbl.textColor = kBlack;
    lbl.font = Font(14);
    [self.view addSubview:lbl];
    
    
    UILabel *message = [[UILabel alloc]init];
    message.frame = kFrame(0, _circle.frame.size.height+_circle.frame.origin.y+30, kScreen_W, 15);
    message.text = _resultDic[@"msg"];
    message.textAlignment = 1;
    message.textColor = kBlack;
    message.font = Font(15);
    [self.view addSubview:message];
}

- (AnswerSheetView *)sheetView
{
    if (!_sheetView) {
        CGFloat width = kScale_W(25) ;
        CGFloat spacing_v = kScale_W(25);
        CGFloat height = spacing_v*5 +width*6+50;
        _sheetView = [[AnswerSheetView alloc]initWithFrame:kFrame(0, _circle.frame.size.height+_circle.frame.origin.y+75, kScreen_W, height) type:1 block:^(NSInteger num) {
           
        }];
    }
    return _sheetView;
}

- (ResultFooterView *)footerView
{
    if (!_footerView) {
        
        _footerView = [[ResultFooterView alloc]initWithFrame:kFrame(0, kScreen_H-45, kScreen_W, 45) block1:^(NSInteger num) {
           NSArray *arr = self.navigationController.viewControllers;
            for (UIViewController *vc in arr) {
                if ([vc isKindOfClass:[SQTestHeadViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        } block2:^(NSInteger num) {
            NSArray *arr = self.navigationController.viewControllers;
            for (UIViewController *vc in arr) {
                if ([vc isKindOfClass:[SQTestListViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
    }
    return _footerView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
