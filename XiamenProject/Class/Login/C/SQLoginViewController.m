//
//  SQLoginViewController.m
//  LeTu
//
//  Created by MacStudent on 2019/5/8.
//  Copyright © 2019 mtt. All rights reserved.
//

#import "SQLoginViewController.h"
#import "SQForgetViewController.h"
#import "SQRegistViewController.h"
#import "PrivacyPolicyViewController.h"
#import "MacroDefinition.h"
#import "UIButton+XXButton.h"


@interface SQLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *pswText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *remeberButton;


@end

@implementation SQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.remeberButton.xx_touchAreaInsets = UIEdgeInsetsMake(15, 15, 15, 10);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)loginActino:(id)sender
{
    if (_telText.text.length == 0) {
        [MBProgressHUD showError:@"请先输入手机号"];
        return;
    }
    if (![_telText.text verifyMobile])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (_remeberButton.selected != YES) {
        [MBProgressHUD showError:@"请先同意《隐私协议》"];
        return;
    }
    if ([Base_AFN_Manager isNetworking]) {
        [self.view endEditing:YES];
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_LOGIN) parameters:@{@"mobile":self.telText.text,@"password":self.pswText.text} success:^(id success) {
         
            if ([success[@"status"] integerValue] == 1) {
                [kUserDefaults setInteger:[success[@"result"][@"type"] integerValue] forKey:@"type"];
                [kUserDefaults setObject:self.telText.text forKey:@"mobile"];
                [kUserDefaults setObject:success[@"result"][@"id"] forKey:@"id"];
                [kUserDefaults setObject:success[@"result"][@"accountId"] forKey:@"accountId"];
                [kUserDefaults setBool:YES forKey:@"isLogin"];
                [MBProgressHUD showSuccess:@"登录成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [MBProgressHUD showError:success[@"msg"]];
            }
           
        } failure_login:nil failure_data:^(id failure) {
           
        } error:^(id error) {
            
        }];
    } else {
        
    }
}
- (IBAction)tip:(id)sender {
    PrivacyPolicyViewController *vc = [PrivacyPolicyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rememberAction:(id)sender
{
//    SQRegistViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"regist_sb"];
//    [self.navigationController pushViewController:vc animated:YES];
    _remeberButton.selected = !_remeberButton.selected;
    if (_remeberButton.selected == YES) {
        _remeberButton.xx_img = [UIImage imageNamed:@"xuanzhong"];
    }
    else
    {
        _remeberButton.xx_img = [UIImage imageNamed:@"weixuanzhong"];
    }
}

- (IBAction)forgetAction:(id)sender
{
    SQForgetViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"forget_sb"];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 119; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.codeButton setTitle:NSLocalizedString(@"重新发送", nil) forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 120;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                NSString *resend = NSLocalizedString(@"重新发送", nil);
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@(%d)", resend,seconds] forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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


