//
//  SQRegistPSWViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/9.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQRegistPSWViewController.h"
#import "SQRegistMessageViewController.h"
#import "MacroDefinition.h"

@interface SQRegistPSWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pswText;
@property (weak, nonatomic) IBOutlet UITextField *sureText;

@end

@implementation SQRegistPSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhite;
    self.isBack = YES;
}

- (IBAction)next:(id)sender
{
    if (_pswText.text.length == 0) {
        [MBProgressHUD showError:@"请先输入新密码"];
        return;
    }
    if (_pswText.text.length < 8) {
        [MBProgressHUD showError:@"密码不能少于8位"];
        return;
    }
    if (_sureText.text.length == 0)
    {
        [MBProgressHUD showError:@"请先确认密码"];
        return;
    }
    if (_sureText.text.length < 8) {
        [MBProgressHUD showError:@"密码不能少于8位"];
        return;
    }
    if (![_pswText.text isEqualToString:_sureText.text])
    {
        [MBProgressHUD showError:@"您输入的密码不一致，请重新输入"];
        return;
    }
    SQRegistMessageViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"setMessage_sb"];
    vc.codeStr = _codeStr;
    vc.phoneStr = _phoneStr;
    vc.passwordStr = _pswText.text;
    [self.navigationController pushViewController:vc animated:YES];
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
