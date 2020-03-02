//
//  SQRegistMessageViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/9.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQRegistMessageViewController.h"
#import "MacroDefinition.h"

@interface SQRegistMessageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *cardNo;
@property (weak, nonatomic) IBOutlet UITextField *dName;
@property (weak, nonatomic) IBOutlet UITextField *dPhone;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UILabel *address_lbl;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation SQRegistMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.title = @"个人信息";
    if (_type == 0) {
        _finishBtn.hidden = YES;
        [self updateUI];
    }
    else
    {
        _finishBtn.hidden = NO;
    }
}
- (IBAction)sure:(id)sender
{
    if (_name.text.length == 0) {
        [MBProgressHUD showError:@"请先输入姓名"];
        return;
    }
    if (_phone.text.length == 0)
    {
        [MBProgressHUD showError:@"请先输入联系电话"];
        return;
    }
    if (_cardNo.text.length == 0)
    {
        [MBProgressHUD showError:@"请先输入身份证号码"];
        return;
    }
    [self regist];
}

- (void)regist
{
    NSDictionary *parameters = @{@"mobile": _phoneStr,@"password":_passwordStr,@"smsCode":_codeStr,@"name":_name.text,@"telNo":_phone.text,@"identityCard":_cardNo.text,@"emergencyContact":kReplace_Str(_dName.text, @""),@"emergencyContactPhone":kReplace_Str(_dPhone.text, @""),@"type":@"1",@"address":kReplace_Str(_address.text, @"")};
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_REGIST) parameters:parameters success:^(id success) {
            
            if (!kIsEmptyObj(success)) {
                //                NSString *codeStr = success[@"msg"];
                
                [MBProgressHUD showSuccess:@"注册成功，请重新登录"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    }
    else {
        
    }
}

- (void)updateUI
{
    _name.text = _model.name;
    _phone.text = _model.telNo;
    _cardNo.text = _model.identityCard;
    _dName.text = _model.emergencyContact;
    _dPhone.text = _model.emergencyContactPhone;
    _address.text = _model.address;
    _address_lbl.hidden = YES;
    _name.userInteractionEnabled = NO;
    _phone.userInteractionEnabled = NO;
    _cardNo.userInteractionEnabled = NO;
    _dName.userInteractionEnabled = NO;
    _dPhone.userInteractionEnabled = NO;
    _address.userInteractionEnabled = NO;
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
