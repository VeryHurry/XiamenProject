//
//  SQForgetViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/9.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQForgetViewController.h"
#import "SQForgetSureViewController.h"
#import "MacroDefinition.h"

@interface SQForgetViewController ()
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;

@property (nonatomic, copy) NSString *code;

@end

@implementation SQForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回登录密码";
    self.isBack = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)getSMS:(id)sender
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
    [self openCountdown];
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_GETSMS) parameters:@{@"phone":self.telText.text} success:^(id success) {
            
            if (!kIsEmptyObj(success)) {
                NSString *codeStr = success[@"msg"];
                __weak typeof(self) weakSelf = self;
                if (!kIsEmptyStr(codeStr)) {
                    NSArray *arr = [codeStr componentsSeparatedByString:@","];
                    [MBProgressHUD showSuccess:@"短信验证码已发送，请注意查收！"];
                    //                    weakSelf.code = [self getNumberFromStr:codeStr];
                    NSString *str = arr[1] ;
                    weakSelf.code = [str substringFromIndex:str.length-6];
                }
            }
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (IBAction)next:(id)sender
{
    if (_telText.text.length == 0) {
         [MBProgressHUD showError:@"请先输入手机号"];
//        [AlertTool showCancelAlertWith:self message:@"请先输入手机号" callbackBlock:nil];
        return;
    }
    if (![_telText.text verifyMobile])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
//        [AlertTool showCancelAlertWith:self message:@"请输入正确的手机号" callbackBlock:nil];
        return;
    }
    if (_codeText.text.length == 0)
    {
       [MBProgressHUD showError:@"请先输入短信验证码"];
        return;
    }
    if (![_codeText.text isEqualToString:_code])
    {
        [MBProgressHUD showError:@"短信验证码有误"];
        return;
    }
    SQForgetSureViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"forgetSure_sb"];
    vc.codeStr = _code;
    vc.phoneStr = _telText.text;
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
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 120;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                NSString *resend = @"重新发送";
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
