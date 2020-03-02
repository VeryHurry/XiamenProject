//
//  SQVehicleLocationViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/13.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQVehicleLocationViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "UIImage+Rotate.h"
#import "RouteAnnotation.h"
#import "MacroDefinition.h"

@interface SQVehicleLocationViewController ()<BMKMapViewDelegate,BMKBusLineSearchDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKSuggestionSearchDelegate,BMKRouteSearchDelegate,BMKLocationManagerDelegate>
//@property (nonatomic,strong)BMKMapView *mapView;
//@property (nonatomic,strong)BMKLocationManager *locService;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@property (nonatomic,strong)BMKPointAnnotation *currentAnnotation;
@property (nonatomic,strong)NSDictionary *currentLocationDic;
@property (nonatomic,strong)BMKPolyline *rideLine;
@property (nonatomic,strong)NSMutableArray *pointsArray;
@property (nonatomic,strong)BMKGeoCodeSearch *searcher;
@property (nonatomic,strong)UIView *functionView;
@property (nonatomic,strong)UIView *infoView;
@property (nonatomic,strong)UILabel *vehicleLabel;
@property (nonatomic,strong)UILabel *addressLabel;

@end

@implementation SQVehicleLocationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isBack = YES;
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexStr:@"#f5f5f5"];
    self.title = @"车辆位置";
    self.pointsArray = [[NSMutableArray alloc]init];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    
    //获取车辆实时位置
    [self getCurrentLocation];
    
    //    获取页面信息
//    [self getCurrentPageInfo];
    
    
    //创建大头针
    self.currentAnnotation = [[BMKPointAnnotation alloc]init];
    //    self.currentAnnotation.title = @"当前位置";
    
    //发送编码请求
    self.searcher = [[BMKGeoCodeSearch alloc]init];
    
    //更多功能
    //    [self setMoreFunction];
    
    [self createInfoUI];
    
    [SocketManager instance].notiBlock = ^(NSDictionary *contentDic) {
        
        //        NSLog(@"收到推送>>>%@",contentDic);
        NSString *jsonString = [NSString stringWithFormat:@"%@",contentDic[@"content"]];
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        //        NSLog(@"%@",dataArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (dataArray) {
                
                [self.pointsArray addObject:dataArray];
                [self drawRect];
                [self moveWithLocationInfo:dataArray];
            }
        });
    };
}

#pragma mark - 车辆信息
-(void)createInfoUI
{
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(15, kScreen_H - 95*Scale, kScreen_W-30, 80*Scale)];
    self.infoView.backgroundColor = [UIColor whiteColor];
    self.infoView.layer.masksToBounds = YES;
    self.infoView.layer.cornerRadius = 4;
    [self.view addSubview:self.infoView];
    
    //    车牌号
    self.vehicleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100*Scale, 20*Scale)];
    self.vehicleLabel.text = self.vehicleNo;
    self.vehicleLabel.textColor = [UIColor blackColor];
    self.vehicleLabel.font = [UIFont systemFontOfSize:14*Scale weight:UIFontWeightRegular];
    [self.infoView addSubview:self.vehicleLabel];
    
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40*Scale, 250*Scale, 40*Scale)];
    self.addressLabel.textColor = [UIColor colorWithHexStr:@"#3b3b3b"];
    self.addressLabel.font = [UIFont systemFontOfSize:12*Scale weight:UIFontWeightRegular];
    self.addressLabel.numberOfLines = 0;
    [self.infoView addSubview:self.addressLabel];
    
    
    //    操作
//    UIButton *operateButton = [[UIButton alloc]init];
//    [operateButton setImage:[UIImage imageNamed:@"btn_oprate"] forState:UIControlStateNormal];
//    [operateButton addTarget:self action:@selector(operateClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.infoView addSubview:operateButton];
//    [operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(-15);
//        make.top.offset(15);
//        make.width.offset(35*Scale);
//        make.height.offset(35*Scale);
//    }];
//    UILabel *operateLabel = [[UILabel alloc]init];
//    operateLabel.text = @"操作";
//    operateLabel.textColor = [UIColor colorWithHexStr:@"#3b3b3b"];
//    operateLabel.font = [UIFont systemFontOfSize:12*Scale weight:UIFontWeightRegular];
//    operateLabel.textAlignment = NSTextAlignmentCenter;
//    [self.infoView addSubview:operateLabel];
//    [operateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(operateButton.mas_centerX).offset(0);
//        make.top.equalTo(operateButton.mas_bottom).offset(0);
//        make.width.offset(40*Scale);
//        make.height.offset(20*Scale);
//    }];
}


#pragma mark - BMKAnnotation
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {

        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.animatesDrop = YES;
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;

        [newAnnotationView setSelected:YES animated:YES];
        newAnnotationView.image = [UIImage imageNamed:@"icon_gpsddc"];

        return newAnnotationView;
    }

    return nil;

}

#pragma mark - 获取当前位置
-(void)getCurrentLocation
{
    
    NSString *url = [NSString stringWithFormat:@"%@/tocs-member-app/letu/gps/vehicle/vehicleRealTime",CARIP];
    NSString *imeiNo = [NSString stringWithFormat:@"%@",self.imeiNo];
    NSDictionary *parameters = @{@"imeiNo":imeiNo};
    
    
    [DataModel getDataWithURL:url parameters:parameters returnBlock:^(NSDictionary *dic) {
        
        NSLog(@"vehicleRealTime>>>%@",dic);
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        if ([status isEqualToString:@"1"]) {
            
            NSDictionary *dataDic = dic[@"result"];
            
            NSString *latitude = [NSString stringWithFormat:@"%@",dataDic[@"latitude"]];
            NSString *longitude = [NSString stringWithFormat:@"%@",dataDic[@"longitude"]];
            
            //GPS坐标转百度坐标
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
            
            //            NSLog(@"百度坐标>>>>%f--%f",GPSCoor.latitude,GPSCoor.longitude);
            //                发起地理编码
            CLLocationCoordinate2D pt = GPSCoor;
            BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
            reverseGeoCodeSearchOption.location = pt;
            [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
            
            self.mapView.centerCoordinate = GPSCoor;
            self.currentAnnotation.coordinate = GPSCoor;
//            [self.mapView removeAnnotation:self.currentAnnotation];
            [self.mapView addAnnotation:self.currentAnnotation];
            
        }else{
            
            [MBProgressHUD showError:@"服务繁忙"];
            
        }
        
    }];
    
    
}

#pragma mark - 获取当前页面
-(void)getCurrentPageInfo
{
    
    NSString *url = [NSString stringWithFormat:@"%@/letu/gps/vehicle/accountCurrentInfo",IP];
    NSString *accountNo = [NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:@"loginAccount"]];
    NSString *imeiNo = [NSString stringWithFormat:@"%@",self.imeiNo];
    NSString *currentPage = @"102";
    
    NSDictionary *parameters = @{@"accountNo":accountNo,@"imeiNo":imeiNo,@"currentPage":currentPage};
    
    [DataModel getDataWithURL:url parameters:parameters returnBlock:^(NSDictionary *dic) {
        
        NSLog(@"accountCurrentInfo>>>%@",dic);
        
    }];
    
    
}

#pragma mark - 位置移动
-(void)moveWithLocationInfo:(NSArray *)locationInfo
{
    
    //    NSString *timeStr = [NSString stringWithFormat:@"%@",locationInfo[0]];
    //    NSString *time = [TimestampModel getLocationTime:timeStr];
    NSString *latitude = [NSString stringWithFormat:@"%@",locationInfo[1]];
    NSString *longitude = [NSString stringWithFormat:@"%@",locationInfo[2]];
    //    NSString *speed = [NSString stringWithFormat:@"%@",locationInfo[3]];
    //    NSString *direction = [NSString stringWithFormat:@"%@",locationInfo[4]];
    
    CLLocationCoordinate2D locationCoor = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    
    NSDictionary *GPSDic = BMKConvertBaiduCoorFrom(locationCoor, BMK_COORDTYPE_GPS);
    NSString *xstr=[GPSDic objectForKey:@"x"];
    NSString *ystr=[GPSDic objectForKey:@"y"];
    NSData *xdata=[[NSData alloc] initWithBase64EncodedString:xstr options:0];
    NSData *ydata=[[NSData alloc] initWithBase64EncodedString:ystr options:0];
    NSString *xlat=[[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
    NSString *ylng=[[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
    locationCoor.latitude=[xlat doubleValue];
    locationCoor.longitude=[ylng doubleValue];
    
    //    发起地理编码
    CLLocationCoordinate2D pt = locationCoor;
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = pt;
    [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    
    [UIView animateWithDuration:5 animations:^{
        
        self.currentAnnotation.coordinate = locationCoor;
        [self.mapView setCenterCoordinate:locationCoor animated:YES];
        
    }];
    
}

#pragma mark - 收到编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.currentAnnotation.title = [NSString stringWithFormat:@"%@",result.address];
    
    NSLog(@"%@",self.currentAnnotation.title);
    
    self.addressLabel.text = result.address;
}

#pragma mark - 划线
-(void)drawRect
{
    
    CLLocationCoordinate2D paths[self.pointsArray.count];
    
    for (int i = 0; i < self.pointsArray.count; i++) {
        
        CLLocationCoordinate2D locationCoor = CLLocationCoordinate2DMake([self.pointsArray[i][1] doubleValue], [self.pointsArray[i][2] doubleValue]);
        
        NSDictionary *GPSDic = BMKConvertBaiduCoorFrom(locationCoor, BMK_COORDTYPE_GPS);
        NSString *xstr=[GPSDic objectForKey:@"x"];
        NSString *ystr=[GPSDic objectForKey:@"y"];
        NSData *xdata=[[NSData alloc] initWithBase64EncodedString:xstr options:0];
        NSData *ydata=[[NSData alloc] initWithBase64EncodedString:ystr options:0];
        NSString *xlat=[[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
        NSString *ylng=[[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
        locationCoor.latitude=[xlat doubleValue];
        locationCoor.longitude=[ylng doubleValue];
        
        paths[i] = locationCoor;
        
    }
    
    
    [self.mapView removeOverlay:self.rideLine];
    
    self.rideLine = [BMKPolyline polylineWithCoordinates:paths count:self.pointsArray.count];
    
    [self.mapView addOverlay:self.rideLine];
    
    
}

-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        
        polylineView.strokeColor = [[UIColor colorWithHexStr:@"#a139e7"] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        
        return polylineView;
    }
    return nil;
    
}



#pragma mark - 定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    NSLog(@"当前的坐标是:%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    self.lat2=userLocation.location.coordinate.latitude;
    //    self.lon2=userLocation.location.coordinate.longitude;
    
    [_mapView updateLocationData:userLocation]; //更新地图上的位置
    
    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    
//    [self.locService stopUpdatingLocation];
    
}

#pragma mark - 更多功能
-(void)setMoreFunction
{
    
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(10, kNav_H+10, 240*Scale, 40*Scale)];
    self.functionView.clipsToBounds = YES;
    self.functionView.backgroundColor = [UIColor whiteColor];
    self.functionView.layer.cornerRadius = 4;
    self.functionView.layer.shadowColor = [UIColor colorWithHexStr:@"#2b2b2b"].CGColor;
    self.functionView.layer.shadowOffset = CGSizeMake(0, 5);
    self.functionView.layer.shadowRadius = 4;
    self.functionView.layer.shadowOpacity = 0.5;
    [self.view addSubview:self.functionView];
    
    
    NSArray *buttonArray = @[@"定位",@"轨迹",@"追踪",@"分享"];
    
    for (int i = 0; i<4; i++) {
        
        UIButton *functionBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*50*Scale, 0, 50*Scale, 40*Scale)];
        functionBtn.tag = 10 + i;
        functionBtn.titleLabel.font = [UIFont systemFontOfSize:13*Scale];
        [functionBtn setTitle:buttonArray[i] forState:UIControlStateNormal];
        [functionBtn setTitleColor:[UIColor colorWithHexStr:@"#3b3b3b"] forState:UIControlStateNormal];
        [functionBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.functionView addSubview:functionBtn];
        
    }
    
    
}

#pragma mark - 点击更多
-(void)moreClick:(UIButton *)btn
{
    NSLog(@"%ld",(long)btn.tag);
}

#pragma mark - 分享
-(void)shareClick
{
   
    
}

#pragma mark - 操作
-(void)operateClick
{
    
    NSLog(@"操作");
    
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.mapView.delegate = self;
//    self.locService.delegate = self;
    self.searcher.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    self.mapView.delegate = nil;
//    self.locService.delegate = nil;
    self.searcher.delegate = nil;
    
}

#pragma mark - BMKLocationManagerDelegate
/**
 @brief 当定位发生错误时，会调用代理的此方法
 @param manager 定位 BMKLocationManager 类
 @param error 返回的错误，参考 CLError
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}

/**
 @brief 该方法为BMKLocationManager提供设备朝向的回调方法
 @param manager 提供该定位结果的BMKLocationManager类的实例
 @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    NSLog(@"用户方向更新");
    
    self.userLocation.heading = heading;
    [_mapView updateLocationData:self.userLocation];
}

/**
 @brief 连续定位回调函数
 @param manager 定位 BMKLocationManager 类
 @param location 定位结果，参考BMKLocation
 @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
//    _pt = location.location.coordinate;
    self.userLocation.location = location.location;
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
    _mapView.centerCoordinate = self.userLocation.location.coordinate;
    
}

//
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.pinColor = BMKPinAnnotationColorRed;
//        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
//        return annotationView;
//    }
//    return nil;
//}

#pragma mark - Lazy loading
- (BMKLocationManager *)locationManager {	
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.distanceFilter = 10;
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = YES;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kNav_H, kScreen_W, kScreen_H-kNav_H)];
        _mapView.showsUserLocation = YES;//显示定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
        _mapView.mapType=BMKMapTypeStandard;//设置地图为空白类型
        _mapView.showsUserLocation=YES;//是否显示定位图层（即我的位置的小圆点）
        _mapView.zoomLevel = 19;//地图显示的级别
       
        
        BMKLocationViewDisplayParam*displayParam = [[BMKLocationViewDisplayParam alloc]init];
        displayParam.isAccuracyCircleShow = false;
        //精度圈是否显示
        displayParam.locationViewOffsetX=0;
        //定位偏移量(经度)
        displayParam.locationViewOffsetY=0;
        //定位偏移量（纬度）
        //        displayParam.locationViewImgName=@"icon";
        //定位图标名称去除蓝色的圈
        [_mapView updateLocationViewWithParam:displayParam];
        
    }
    return _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
