//
//  SQScanResultViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/4.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQScanResultViewController.h"
#import "SQVehicleMessageViewController.h"
#import "MacroDefinition.h"


@interface SQScanResultViewController ()

//空闲状态可以绑定
@property (weak, nonatomic) IBOutlet UIView *freeView;
@property (weak, nonatomic) IBOutlet UILabel *chassisNo;
@property (weak, nonatomic) IBOutlet UILabel *colorLbl;
@property (weak, nonatomic) IBOutlet UILabel *manufacturer;

//不是一个公司
@property (weak, nonatomic) IBOutlet UIView *noCompanyView;

//已被同事绑定
@property (weak, nonatomic) IBOutlet UIView *isBingingView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (nonatomic, copy) NSString *telStr;

//已被本人绑定
@property (weak, nonatomic) IBOutlet UIView *bingView;

//绑定成功提示框
@property (weak, nonatomic) IBOutlet UIView *BingSuccessView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (nonatomic, copy) NSString *ID;
@end

@implementation SQScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    [self getVehicleInformation:_qrCode];
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

#pragma mark - network
//扫码获取车辆信息
- (void)getVehicleInformation:(NSString *)code
{
    NSLog(@"----------%@",[kUserDefaults objectForKey:@"mobile"]);
    [Base_AFN_Manager postUrl:IP_SPLICE(IP_VehicleInformation) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"] ,@"qrCode":code} success:^(id success) {
        self.ID = success[@"result"][@"id"];
        NSInteger status = [success[@"status"] integerValue];
        /*
         -1:失败状态
        1：不是同一公司下的车辆
        2：车辆未被绑定
        3：车辆是本人绑定
        4：该车已被他人绑定
         */
        if (status == 1)
        {
            self.noCompanyView.hidden = NO;
            self.isBingingView.hidden = YES;
            self.freeView.hidden = YES;
            self.bingView.hidden = YES;
        }
        else if (status == 2)
        {
            self.freeView.hidden = NO;
            self.isBingingView.hidden = YES;
            self.noCompanyView.hidden = YES;
            self.bingView.hidden = YES;
            self.chassisNo.text = success[@"result"][@"vin"];
            self.colorLbl.text = success[@"result"][@"color"];
            self.manufacturer.text = success[@"result"][@"manufacturers"];
        }
        else if (status == 3)
        {
            self.bingView.hidden = NO;
            self.isBingingView.hidden = YES;
            self.noCompanyView.hidden = YES;
            self.freeView.hidden = YES;
        }
        else if (status == 4)
        {
            self.isBingingView.hidden = NO;
            self.bingView.hidden = YES;
            self.noCompanyView.hidden = YES;
            self.freeView.hidden = YES;
            self.nameLbl.text = success[@"result"][@"userName"];
            self.telStr = success[@"result"][@"telNo"];
        }
        else
        {
            [MBProgressHUD showMessag:success[@"msg"] toView:kWindow andShowTime:1.5];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
    } failure_login:nil failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
}

//绑定车辆
- (void)bindingVehicle:(NSString *)code
{
    
    [Base_AFN_Manager postUrl:IP_SPLICE(IP_BindVehicle) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"] ,@"qrCode":code} success:^(id success) {
        if (!kIsEmptyObj(success)&&[success[@"msg"] rangeOfString:@"成功"].length != 0) {
            self.bingView.hidden = YES;
            self.isBingingView.hidden = YES;
            self.noCompanyView.hidden = YES;
            self.freeView.hidden = YES;
            
            self.BingSuccessView.hidden = NO;
            [self countDown];
        }
        else
        {
            [MBProgressHUD showError:success[@"msg"]];
        }
        
        
    } failure_login:nil failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
    
}

//解绑车辆
- (void)unBindingVehicle:(NSString *)code
{
    
    [Base_AFN_Manager postUrl:IP_SPLICE(IP_UnBindVehicle) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"] ,@"qrCode":code} success:^(id success) {
        if (!kIsEmptyObj(success)&&[success[@"msg"] rangeOfString:@"成功"].length != 0) {
            [MBProgressHUD showSuccess:success[@"msg"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showError:success[@"msg"]];
            
        }
        
        
    } failure_login:nil failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
    
}


#pragma mark - action

- (IBAction)binging:(id)sender
{
    [self bindingVehicle:self.qrCode];
}

- (IBAction)unBinging:(id)sender
{
    [self unBindingVehicle:self.qrCode];
}

- (IBAction)backHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)contact:(id)sender
{
    NSMutableString *str2=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telStr];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str2]]];
    [self.view addSubview:callWebview];
}
- (IBAction)more:(id)sender
{
    SQVehicleMessageViewController *vc = [SQVehicleMessageViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.cid = self.ID;
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private
- (void)countDown
{
    __block int timeout=3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0)
        { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        else
        {
            NSString *strTime = [NSString stringWithFormat:@"%d",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLbl.text = strTime;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
