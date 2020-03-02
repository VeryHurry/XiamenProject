//
//  SQVehicleManagementViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/3.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQVehicleManagementViewController.h"
#import "SQVehicleLocationViewController.h"
#import "SportPathDemoViewController.h"
#import "SQStatisticalViewController.h"
#import "VehicleModel.h"
#import "MacroDefinition.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface SQVehicleManagementViewController ()<BMKGeoCodeSearchDelegate>
@property (weak, nonatomic) IBOutlet UILabel *vehicleNo;
@property (weak, nonatomic) IBOutlet UILabel *mileageOfTheDayAE;//当日历程
@property (weak, nonatomic) IBOutlet UILabel *power;//电压
@property (weak, nonatomic) IBOutlet UILabel *almrmState;//警报
@property (weak, nonatomic) IBOutlet UILabel *chefang;//设防
@property (weak, nonatomic) IBOutlet UILabel *powerOnAE;//电源
@property (weak, nonatomic) IBOutlet UILabel *address;//地址
@property (weak, nonatomic) IBOutlet UILabel *time;//时间
@property (weak, nonatomic) IBOutlet UILabel *totalMileageAE;

@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (nonatomic,assign)int gpsStrength;
@property (nonatomic, strong) VehicleModel *model;

@property (nonatomic,strong)BMKGeoCodeSearch *searcher;

@end

@implementation SQVehicleManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.title = @"车辆管理";
    [self getCurrentPageInfo];
    
}

- (void)createUI
{
    self.vehicleNo.text = self.model.vehicleNo;
    self.mileageOfTheDayAE.text = kIsEmptyStr(self.model.mileageOfTheDayAE)?@"0" :self.model.mileageOfTheDayAE;
    self.power.text = kIsEmptyStr(self.model.mainPowerSupplyVoltageAE)?@"0" :self.model.mainPowerSupplyVoltageAE;
    
    self.almrmState.text = !kIsEmptyStr(self.model.almrmState)&&[self.model.almrmState isEqualToString:@"1"]?   @"警报 ON" :@"警报 OFF";
    self.chefang.text = !kIsEmptyStr(self.model.chefang)&&[self.model.chefang isEqualToString:@"1"]?   @"设防 ON" :@"设防 OFF";
    self.powerOnAE.text = !kIsEmptyStr(self.model.almrmState)&&[self.model.almrmState isEqualToString:@"1"]?   @"电源 ON" :@"电源 OFF";
    self.time.text = self.model.realTime;
    self.totalMileageAE.text = self.model.totalMileageAE;
    
    NSString *gpsStrenthStr = [NSString stringWithFormat:@"%@",self.model.gpsSignStrength];
    self.gpsStrength = [gpsStrenthStr intValue];
    //    GPS
    UILabel *gpsLabel = [[UILabel alloc] init];
    gpsLabel.text = @"GPS";
    gpsLabel.textAlignment = 2;
    gpsLabel.textColor = [UIColor colorWithHexStr:@"#999999"];
    gpsLabel.font = [UIFont systemFontOfSize:13];
    [self.locationView addSubview:gpsLabel];
    [gpsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locationView.mas_right).offset(-30-6*7*Scale-5*Scale);
        make.centerY.equalTo(self.locationView.mas_centerY).offset(0);
        make.width.offset(30);
    }];
    
    
    for (int i = 0; i<6; i++) {
        
        if (i < self.gpsStrength) {
            UIImageView *verticalBlackView = [[UIImageView alloc]init];
            verticalBlackView.image = [UIImage imageNamed:@"GSM_black"];
            [self.locationView addSubview:verticalBlackView];
            [verticalBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(gpsLabel.mas_right).offset(5+i*7*Scale);
                make.centerY.equalTo(gpsLabel.mas_centerY).offset(0);
                make.width.offset(3*Scale);
                make.height.offset(12*Scale);
            }];
        }
        else
        {
            UIImageView *verticalView = [[UIImageView alloc]init];
            verticalView.image = [UIImage imageNamed:@"GSM_gray"];
            [self.locationView addSubview:verticalView];
            [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(gpsLabel.mas_right).offset(5+i*7*Scale);
                make.centerY.equalTo(gpsLabel.mas_centerY).offset(0);
                make.width.offset(3*Scale);
                make.height.offset(12*Scale);
            }];
        }
        
        
    }
    
    //    发起地理编码
    self.searcher = [[BMKGeoCodeSearch alloc]init];
    self.searcher.delegate = self;
    
    NSString *latitude = [NSString stringWithFormat:@"%@",self.model.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%@",self.model.longitude];
    //        GPS坐标转百度坐标
    CLLocationCoordinate2D GPSCoor = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    NSDictionary *GPSDic = BMKConvertBaiduCoorFrom(GPSCoor, BMK_COORDTYPE_GPS);
    NSString *xstr=[GPSDic objectForKey:@"x"];
    NSString *ystr=[GPSDic objectForKey:@"y"];
    NSData *xdata=[[NSData alloc] initWithBase64EncodedString:xstr options:0];
    NSData *ydata=[[NSData alloc] initWithBase64EncodedString:ystr options:0];
    NSString *xlat=[[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
    NSString *ylng=[[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
    GPSCoor.latitude=[xlat doubleValue];
    GPSCoor.longitude=[ylng doubleValue];
    
//    CLLocationCoordinate2D pt = BMKCoordTrans(GPSCoor, 0, 2);
    
    //        发起地理编码
    CLLocationCoordinate2D pt = GPSCoor;
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = pt;
    [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"当前停留地址>>>%@",result.address);
    self.address.text = result.address;
}

#pragma mark - network
//获取当前页面
-(void)getCurrentPageInfo
{
    if ([Base_AFN_Manager isNetworking]) {
        
        NSDictionary *dic = @{@"accountNo":[kUserDefaults objectForKey:@"mobile"],@"imeiNo":_imeiNo,@"cityName":@"厦门"};
        [Base_AFN_Manager postUrl:IP_SPLICECAR(IP_VehicleInfo) parameters:dic success:^(id success) {
//            if ([success[@"status"] integerValue] ==1) {
                self.model = [VehicleModel mj_objectWithKeyValues:success[@"result"]];
                [self createUI];
//            }
//            else
//            {
//                [MBProgressHUD showMessag:success[@"msg"] toView:kWindow andShowTime:1.5];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (IBAction)location:(id)sender
{
    SQVehicleLocationViewController *vc = [SQVehicleLocationViewController new];
    vc.imeiNo = _imeiNo;
    vc.vehicleNo = self.model.vehicleNo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)history:(id)sender
{
    SportPathDemoViewController *vc = [SportPathDemoViewController new];
    vc.imeiNo = _imeiNo;
    vc.vehicleNo = self.model.vehicleNo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)total:(id)sender
{
    SQStatisticalViewController *vc = [SQStatisticalViewController new];
    vc.imeiNo = _imeiNo;
    vc.vehicleNo = self.model.vehicleNo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)chengdu:(id)sender
{
    
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
