//
//  SQForgetSureViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/9.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQForgetSureViewController.h"
#import "MacroDefinition.h"

@interface SQForgetSureViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pswText;
@property (weak, nonatomic) IBOutlet UITextField *sureText;

@end

@implementation SQForgetSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)sureAction:(id)sender
{
    if (_pswText.text.length == 0) {
         [MBProgressHUD showError:@"请先输入新密码"];
        return;
    }
    if (_sureText.text.length == 0)
    {
        [MBProgressHUD showError:@"请先确认密码"];
        return;
    }
    if (![_pswText.text isEqualToString:_sureText.text])
    {
        [MBProgressHUD showError:@"您输入的密码不一致，请重新输入"];
        return;
    }
    [self changePassword];
    
}

- (void)changePassword
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_PASSWORD_FORGET) parameters:@{@"mobile":_phoneStr,@"smsCode":_codeStr,@"newPassword1":_pswText.text,@"newPassword2":_sureText.text} success:^(id success) {
            
            if (!kIsEmptyObj(success)) {
               
                [MBProgressHUD showSuccess:@"重置密码成功，请重新登录"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            }
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    }
    else {
        
    }
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
