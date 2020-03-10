//
//  SQFiveResultViewController.m
//  XiamenProject
//
//  Created by mac on 2020/3/6.
//  Copyright © 2020 MacStudent. All rights reserved.
//

#import "SQFiveResultViewController.h"
#import "SQTestListViewController.h"
#import "SQAnswerViewController.h"
#import "MacroDefinition.h"

@interface SQFiveResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *reTest;
@property (weak, nonatomic) IBOutlet UIButton *reLearn;

@end

@implementation SQFiveResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考核结果";
    self.isBack = YES;
    self.view.backgroundColor = kWhite;
    [self updateUI];
}

- (void)updateUI
{
    if ([_result rangeOfString:@"未正确"].length != 0) {
        _reTest.hidden = NO;
        _reLearn.hidden = NO;
        _closeBtn.hidden = YES;
        _icon.image = [UIImage imageNamed:@"未通过"];
        _titleLbl.text = @"很遗憾，您未通过考核";
    }
    else
    {
        _reTest.hidden = YES;
        _reLearn.hidden = YES;
        _closeBtn.hidden = NO;
        _icon.image = [UIImage imageNamed:@"通过"];
        _titleLbl.text = @"恭喜您通过考核啦";
    }
    
    [_reTest xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        SQAnswerViewController *vc = [SQAnswerViewController new];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [_reLearn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        SQTestListViewController *vc = [SQTestListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [_closeBtn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
