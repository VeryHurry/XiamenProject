//
//  SQVehicleMessageViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/21.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQVehicleMessageViewController.h"
#import "MyVehicleModel.h"
#import "MacroDefinition.h"

@interface SQVehicleMessageViewController ()

@property (nonatomic ,strong) result *model;
@property (weak, nonatomic) IBOutlet UILabel *NoLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *useTime;
@property (weak, nonatomic) IBOutlet UILabel *licheng;
@property (weak, nonatomic) IBOutlet UILabel *sudu;
@property (weak, nonatomic) IBOutlet UILabel *dianya;
@property (weak, nonatomic) IBOutlet UILabel *chejiahao;
@property (weak, nonatomic) IBOutlet UILabel *qiye;
@property (weak, nonatomic) IBOutlet UILabel *changjia;
@property (weak, nonatomic) IBOutlet UILabel *jingxiaoshan;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation SQVehicleMessageViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn.hidden = _type == 1 ? YES : NO;
    [self getMessage];
}

- (void)updateUI
{
    _NoLbl.text = self.model.headingCode;
    _useTime.text = self.model.totalTime;
    _timeLbl.text = self.model.startTime;
    _licheng.text = kIsEmptyStr(self.model.mileageOfTheDayAE) ? @"0" :self.model.mileageOfTheDayAE;
   
    _sudu.text = kIsEmptyStr(self.model.speed) ? @"0" :self.model.speed;
    _dianya.text = kIsEmptyStr(self.model.mainPowerSupplyVoltageAE) ? @"0" :self.model.mainPowerSupplyVoltageAE;
    _chejiahao.text = self.model.vin;
    _qiye.text = self.model.parentName;
    _changjia.text = self.model.manufacturers;
    _jingxiaoshan.text = self.model.dealer;
}


#pragma mark - Network
- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_VehicleMessage) parameters:@{@"id":self.cid} success:^(id success) {
            if (!kIsEmptyObj(success)) {
                self.model = [result mj_objectWithKeyValues:success[@"result"]];
                [self updateUI];
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (IBAction)unBind:(id)sender
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_UnBindVehicle) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"],@"qrCode":self.model.qrCode} success:^(id success) {
            if (!kIsEmptyObj(success)) {
                [MBProgressHUD showMessag:@"解绑成功" toView:kWindow andShowTime:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
