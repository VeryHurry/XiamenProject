//
//  SQTestHeadViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/13.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQTestHeadViewController.h"
#import "SQAnswerViewController.h"
#import "MacroDefinition.h"

@interface SQTestHeadViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainView;

@end

@implementation SQTestHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.title = @"安全教育";
    NSURL *url = [NSURL URLWithString:IP_SPLICE(IP_TestWeb)];
    [self.mainView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)start:(id)sender
{
    [AlertTool showAlertWith:self title:@"考试说明" message:@"请左右滑动切换考题，本次考试共30题，完成所有题目方可提交试卷。" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:@[] callbackBlock:^(NSInteger btnIndex) {
        __weak __typeof(self) wself = self;
        if (btnIndex == -1) {
            SQAnswerViewController *vc = [SQAnswerViewController new];
            vc.examinationNo = wself.examinationNo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
//    [AlertTool showDefaultAlertWith:self message:@"aaa" callbackBlock:^(NSInteger btnIndex) {
//        
//    }];
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
