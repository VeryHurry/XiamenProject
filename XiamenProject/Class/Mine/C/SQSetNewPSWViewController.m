//
//  SQSetNewPSWViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/26.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQSetNewPSWViewController.h"
#import "MacroDefinition.h"

@interface SQSetNewPSWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldText;
@property (weak, nonatomic) IBOutlet UITextField *pswText;
@property (weak, nonatomic) IBOutlet UITextField *sureText;

@end

@implementation SQSetNewPSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhite;
    self.isBack = YES;
    self.title = @"修改密码";
}

- (IBAction)next:(id)sender
{
    if (_oldText.text.length == 0) {
        [MBProgressHUD showError:@"请先输入旧密码"];
        return;
    }
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
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_UserInfo) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"],@"password":_oldText.text,@"newPassword1":_pswText.text,@"newPassword2":_sureText.text} success:^(id success) {
            if (!kIsEmptyObj(success)) {
                [MBProgressHUD showMessag:success[@"msg"] toView:kWindow andShowTime:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
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
