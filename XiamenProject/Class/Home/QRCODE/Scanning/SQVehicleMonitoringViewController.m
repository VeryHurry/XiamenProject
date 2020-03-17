//
//  SQVehicleMonitoringViewController.m
//  XiamenProject
//
//  Created by mac on 2019/12/6.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQVehicleMonitoringViewController.h"
#import "SQViolationsFeedbackViewController.h"
#import "SQViolationsViewController.h"
#import "CarICurrentInfoModel.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "MacroDefinition.h"
#import "UIImageView+WebCache.h"

@interface SQVehicleMonitoringViewController ()<BMKGeoCodeSearchDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *manufacturers;
@property (weak, nonatomic) IBOutlet UILabel *imeiNo;
@property (weak, nonatomic) IBOutlet UILabel *headingCode;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *parentName;
@property (weak, nonatomic) IBOutlet UILabel *legalPerson;
@property (weak, nonatomic) IBOutlet UIButton *parentMobile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *accounted;
@property (weak, nonatomic) IBOutlet UILabel *integral;
@property (weak, nonatomic) IBOutlet UILabel *breakthelaw;
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@property (nonatomic, strong) CarICurrentInfoModel *model;

@property (weak, nonatomic) IBOutlet UIButton *photoBtn;

@property (nonatomic, assign) CLLocationCoordinate2D coord;

@property (nonatomic, strong) BMKGeoCodeSearch *searchAddress;

@property (nonatomic, strong) BMKReverseGeoCodeSearchOption *mapOption;


@end

@implementation SQVehicleMonitoringViewController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.isBack = YES;
    self.photoBtn.xx_cornerRadius = self.photoBtn.xx_height/2;
    [self.photoBtn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
       
            SQViolationsFeedbackViewController *vc = [[SQViolationsFeedbackViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.mobile = self.model.mobile;
            vc.address = self.address.text;
            if (!kIsEmptyStr(self.model.accounted)) {
                vc.accounted = self.model.accounted;
            }
            else
            {
                if (!kIsEmptyStr(self.model.parentId)) {
                    vc.parentId = self.model.parentId;
                    vc.parentName = self.model.parentName;
                }
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        
    }];
    [self.parentMobile xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (!kIsEmptyStr(self.model.legalPersontel)) {
            NSString *phoneNumber = [NSString stringWithFormat:@"tel:%@",self.model.legalPersontel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
        
    }];
    [self VehicleCurrentMessage];
    
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)VehicleCurrentMessage
{
    
    [Base_AFN_Manager postUrl:IP_SPLICE(IP_CarCurrentInfo) parameters:@{@"qrCode":self.qrCode} success:^(id success) {
        if (!kIsEmptyObj(success)) {
            self.model = [CarICurrentInfoModel mj_objectWithKeyValues:success];
            [self updataUI];
        }
        else
        {
            [MBProgressHUD showError:success[@"msg"]];
        }
        
        
    } failure_login:nil failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
    
}

- (void)updataUI
{
    self.manufacturers.text = _model.manufacturers;
    self.imeiNo.text = _model.imeiNo;
    self.headingCode.text = _model.headingCode;
    self.updateTime.text = _model.updateTime;
    self.parentName.text = _model.parentName;
    self.legalPerson.text = _model.legalPerson;
    self.name.text = kIsEmptyStr(_model.name) ? @"暂无绑定" : _model.name;
    self.mobile.text = kIsEmptyStr(_model.mobile) ? @"暂无" : _model.mobile;
    self.accounted.text = kIsEmptyStr(_model.accounted) ? @"" : [NSString stringWithFormat:@"（编号：%@）",_model.accounted];
    self.integral.text = [NSString stringWithFormat:@"剩余积分：%ld分",(long)_model.integral];
    self.breakthelaw.text = [NSString stringWithFormat:@"违章记录：共%ld条",(long)_model.breakthelaw];
    if (_model.breakthelaw == 0) {
        self.lookBtn.hidden = YES;
    }
    else
    {
        self.lookBtn.hidden = NO;
    }
    
    if (kIsEmptyStr(_model.headimg)) {
        self.headimg.backgroundColor = kLightGray;
    }
    else
    {
        [self.headimg sd_setImageWithURL:kImageUrl(_model.headimg) placeholderImage:[UIImage imageNamed:@"me_bt_head"]];
    }
    
    
    NSString *status;
    NSInteger state = _model.status;
    if (state == 1) {
        status = @"申请";
    }
    else if (state == 2)
    {
        status = @"审核通过";
    }
    else if (state == 3)
    {
        status = @"审核拒绝";
    }
    else if (state == 4)
    {
        status = @"违规停用";
    }
    else if (state == 5)
    {
        status = @"车辆到期";
    }
    else if (state == 6)
    {
        status = @"注销";
    }
    else if (state == 7)
    {
        status = @"设备号已绑定";
    }
    else if (state == 8)
    {
        status = @"骑手已绑定";
    }
    else if (state == -1)
    {
        status = @"未绑定";
    }
    
    NSInteger acc = _model.acc;
    if (acc == 0) {
        status = [NSString stringWithFormat:@"%@|ACC关闭",status];
    }
    else
    {
        status = [NSString stringWithFormat:@"%@|ACC打开",status];
    }
    
    NSString *speed = kIsEmptyStr(_model.speed) ? @"0" :_model.speed;
    
    
    status = [NSString stringWithFormat:@"%@|%@km/h|%@",status,speed,[self getDirectionWithAngle:_model.direction]];
    self.status.text = status;
    
    [self getAddress:_model.latitude longitude:_model.longitude];
    
}

#pragma mark - 角度转为方向
-(NSString *)getDirectionWithAngle:(CGFloat)angle
{
    
    if (angle == 0) {
        
        return @"正北向";
    }else if (angle > 0 && angle < 30){
        
        return @"北向";
    }else if (angle >= 30 && angle <= 60){
        
        return @"东北向";
    }else if (angle > 60 && angle < 90){
        
        return @"东向";
    }else if (angle == 90){
        
        return @"正东向";
    }else if (angle > 90 && angle < 120){
        
        return @"东向";
    }else if (angle >= 120 && angle <= 150){
        
        return @"东南向";
    }else if (angle > 150 && angle < 180){
        
        return @"南向";
    }else if (angle == 180){
        
        return @"正南向";
    }else if (angle > 180 && angle < 210){
        
        return @"南向";
    }else if (angle >= 210 && angle <= 240){
        
        return @"西南向";
    }else if (angle > 240 && angle < 270){
        
        return @"西向";
    }else if (angle == 270){
        
        return @"正西向";
    }else if (angle > 270 && angle < 300){
        
        return @"西向";
    }else if (angle >= 300 && angle <= 330){
        
        return @"西北向";
    }else if (angle > 330 && angle <= 360){
        
        return @"北向";
    }else{
        
        return @"北向";
    }
    
    
}


- (void)getAddress:(NSString *)latitude longitude:(NSString *)longitude
{
    CLLocationCoordinate2D GPSCoor = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    _mapOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    _mapOption.location = GPSCoor;
    _searchAddress = [[BMKGeoCodeSearch alloc] init];
    _searchAddress.delegate = self;
    [_searchAddress reverseGeoCode:_mapOption];
}


#pragma mark - 收到编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.address.text = result.address;
}

- (IBAction)look:(id)sender
{
    if (!kIsEmptyStr(_model.mobile)) {
        SQViolationsViewController *vc = [[SQViolationsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mobile = _model.mobile;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end


