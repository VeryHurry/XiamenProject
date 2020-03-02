//
//  SportPathDemoViewController.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/6/15.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SportPathDemoViewController.h"
#import "GPS_ChoiceViewController.h"
#import "JSONKit.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "UIImage+Rotate.h"
#import "RouteAnnotation.h"
#import "MacroDefinition.h"
#import "TimestampModel.h"
// 运动结点信息类
@interface BMKSportNode : NSObject

//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//方向（角度）
@property (nonatomic, assign) CGFloat angle;
//距离
@property (nonatomic, assign) CGFloat distance;
//速度
@property (nonatomic, assign) CGFloat speed;
//当前时间
@property (nonatomic, copy) NSString * currentTime;

@property (nonatomic,copy) NSString * timestamp;

@end

@implementation BMKSportNode

@synthesize coordinate = _coordinate;
@synthesize angle = _angle;
@synthesize distance = _distance;
@synthesize speed = _speed;
@synthesize currentTime = _currentTime;
@synthesize timestamp = _timestamp;

@end

// 自定义BMKAnnotationView，用于显示运动者
@interface SportAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SportAnnotationView

@synthesize imageView = _imageView;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 20.f, 32.f)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 32.f)];
        _imageView.image = [UIImage imageNamed:@"GPS_Car.png"];
        [self addSubview:_imageView];
    }
    return self;
}

@end

@interface SportPathDemoViewController ()<BMKMapViewDelegate,BMKBusLineSearchDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKSuggestionSearchDelegate,BMKRouteSearchDelegate,BMKLocationManagerDelegate>
{
    BMKPolyline *pathPloyline;
    BMKPointAnnotation *sportAnnotation;
    SportAnnotationView *sportAnnotationView;

    NSMutableArray *sportNodes;//轨迹点数组
    NSInteger sportNodeNum;//轨迹点数
    NSInteger currentIndex;//当前结点
    BOOL isAnimate;
}

@property (nonatomic,strong)BMKMapView *mapView;
@property (nonatomic,strong)BMKLocationManager *locService;
@property (nonatomic,strong)BMKGeoCodeSearch *searcher;//地理编码
@property (nonatomic,strong)UIView *speedView;
@property (nonatomic,strong)UIView *progressView;
@property (nonatomic,strong)UIButton *playButton;
@property (nonatomic,assign)BOOL isPlay;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSArray *pointsArray;
@property (nonatomic,strong)BMKPolylineView *polylineView;
@property (nonatomic,strong)UISlider *progressSlider;
@property (nonatomic,assign)NSInteger timeType;
@property (nonatomic,assign)int totalPage;
@property (nonatomic,assign)int pageIndex;
@property (nonatomic,assign)int carSpeed;
@property (nonatomic,strong)NSMutableArray *geoArray;
@property (nonatomic,assign)BOOL isFirstLine;
@property (nonatomic,strong)NSMutableArray *secondLineArray;
@property (nonatomic,strong)BMKPolyline *secondPolyLine;
@property (nonatomic,strong)NSMutableArray *parkPointsArray;
@property (nonatomic,strong)UIButton *parkButton;
@property (nonatomic,strong)UIView *customSelectView;
@property (nonatomic,strong)UIView *customPickerView;
@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,strong)UILabel *vehicleLabel;
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *speedLabel;
@property (nonatomic,strong)UILabel *playSpeedLabel;
@end

@implementation SportPathDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"历史轨迹";
    self.pointsArray = [[NSArray alloc]init];
    self.secondLineArray = [[NSMutableArray alloc]init];
    self.parkPointsArray = [[NSMutableArray alloc]init];
    sportNodes = [[NSMutableArray alloc] init];
    
    self.geoArray = [[NSMutableArray alloc]init];//地理位置
    self.pageIndex = 1;
    currentIndex = 0;
    self.carSpeed = 61;
    self.startTime = @"";
    self.endTime = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_return"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"请选择时间" style:UIBarButtonItemStylePlain target:self action:@selector(loadChoiceController)];
    
    
//    地图视图
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,kNav_H, kScreen_W, kScreen_H-kNav_H)];
//    self.mapView.delegate = self;
    self.mapView.backgroundColor = [UIColor clearColor];
    [self.mapView setMapType:BMKMapTypeStandard];
//    [self.mapView setTrafficEnabled:YES];
    [self.mapView setBuildingsEnabled:YES];
    [self.mapView setShowMapPoi:YES];
    [self.mapView setZoomLevel:15.0];
//    self.mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    
    self.mapView.rotateEnabled = YES; //设置是否可以旋转
    
//    初始位置
    [self.view addSubview:self.mapView];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
//    _mapView.showsUserLocation = YES;//显示定位图层定位罗盘模式
    
    
//  初始化BMKLocationService
    self.locService = [[BMKLocationManager alloc]init];
    self.locService.desiredAccuracy = kCLLocationAccuracyBest;
    self.locService.distanceFilter = kCLDistanceFilterNone;
    
//    开始定位
    [self.locService startUpdatingLocation];


    
//    创建进度条
    [self createSlider];
    
//    加载选择页面
    [self loadChoiceController];
    
    
//    初始化检索对象
    self.searcher = [[BMKGeoCodeSearch alloc]init];
    
    
//    显示停车点按钮
    self.parkButton = [[UIButton alloc]init];
    self.parkButton.selected = YES;
    [self.parkButton setBackgroundImage:[UIImage imageNamed:@"stop_gray"] forState:UIControlStateNormal];
    [self.parkButton setBackgroundImage:[UIImage imageNamed:@"stop_blue"] forState:UIControlStateSelected];
    [self.parkButton addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.parkButton];
    [self.parkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.top.offset(kNav_H + 30*Scale);
        make.width.offset(40*Scale);
        make.height.offset(40*Scale);
    }];
    
    
    
}


#pragma mark - 查询历史轨迹点页数
-(void)getHistoryPointWithType:(NSInteger)type
{
    
    NSString *url = [NSString stringWithFormat:@"%@/tocs-member-app/letu/gps/vehicle/historyTrackCountIos",CARIP];
    
    NSString *accountNo = [NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:@"mobile"]];
    NSString *vehicleNo = [NSString stringWithFormat:@"%@",self.vehicleNo];
    NSString *imeiNo = [NSString stringWithFormat:@"%@",self.imeiNo];
    NSString *trackType = [NSString stringWithFormat:@"%ld",(long)type];
    NSString *startTime = [NSString stringWithFormat:@"%@",self.startTime];
    NSString *endTime = [NSString stringWithFormat:@"%@",self.endTime];
    if ([endTime isEqualToString:@"(null)"]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        endTime = [formatter stringFromDate:date];
    }
    
    NSDictionary *parameters = @{@"accountNo":accountNo,@"vehicleNo":vehicleNo,@"imeiNo":imeiNo,@"trackType":trackType,@"startTime":startTime,@"endTime":endTime};
    
    NSLog(@"参数>>>%@",parameters);
    
    [DataModel getDataWithURL:url parameters:parameters returnBlock:^(NSDictionary *dic) {
        
        NSLog(@"查询结果>>>%@",dic);
        NSLog(@"%@",dic[@"msg"]);
        
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        
        if ([status isEqualToString:@"1"]) {
            
            NSString *totalpage = [NSString stringWithFormat:@"%@",dic[@"page"]];
            int page = [totalpage intValue];
            if (page > 0) {
                
                self.totalPage = page;
                [self createTimer];
                
            }
            
        }else{
            
            [MBProgressHUD showError:@"查询失败"];
            
        }
        
    }];
    
    
}

#pragma mark - 获取每一页的点数
-(void)getHistoryPointPerPage
{
    
    NSString *url = [NSString stringWithFormat:@"%@/tocs-member-app/letu/gps/vehicle/historyTrackIos",CARIP];
    
    NSString *accountNo = [NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:@"mobile"]];
    NSString *vehicleNo = [NSString stringWithFormat:@"%@",self.vehicleNo];
    NSString *imeiNo = [NSString stringWithFormat:@"%@",self.imeiNo];
    NSString *trackType = [NSString stringWithFormat:@"%ld",(long)self.timeType];
    NSString *startTime = [NSString stringWithFormat:@"%@",self.startTime];
    NSString *endTime = [NSString stringWithFormat:@"%@",self.endTime];
    if ([endTime isEqualToString:@"(null)"]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        endTime = [formatter stringFromDate:date];
    }
    
    NSString *page = [NSString stringWithFormat:@"%d",self.pageIndex];
    
    NSDictionary *parameters = @{@"accountNo":accountNo,@"vehicleNo":vehicleNo,@"imeiNo":imeiNo,@"trackType":trackType,@"startTime":startTime,@"endTime":endTime,@"page":page};
    
    [DataModel getDataWithURL:url parameters:parameters returnBlock:^(NSDictionary *dic) {
        
//        NSLog(@"%@",dic);
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        if ([status isEqualToString:@"-1"]) {
            
            [MBProgressHUD showMessag:@"暂无轨迹" toView:kWindow andShowTime:1];
            
            [self.timer invalidate];
            self.timer = nil;
            
        }else{
            
            NSString *jsonString = [NSString stringWithFormat:@"%@",dic[@"result"]];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            if ([[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSDictionary class]]) {
                
                NSLog(@"这是字典");
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dataDic);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    初始化轨迹点
                    self.pointsArray = [NSArray arrayWithObject:dataDic];
                    [self initSportNodes];
                    [self start];
//                    [self running];
                });
                
            }else if ([[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSArray class]])
            {
                
                NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"历史轨迹点--%ld条>>>%@",(long)dataArray.count,dataArray);
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    初始化轨迹点
                    
                    self.pointsArray = dataArray;
                    [self initSportNodes];
                    [self start];
//                    [self running];
                });
            }
            
        }
        
    }];
    
    
}

#pragma mark - 创建定时器
-(void)createTimer
{
    
    if (self.timer == nil) {
        
        NSLog(@"开启定时器");
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
}

#pragma mark - 定时器方法
-(void)onTimer
{
    
    if (self.pageIndex > self.totalPage) {
        
        return ;
    }else{
        
        [self getHistoryPointPerPage];
        
        self.pageIndex ++;
    }
    
    
}

//初始化轨迹点
- (void)initSportNodes {
    
    //读取数据
//    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport_path" ofType:@"json"]];

    if (self.pointsArray) {
//        NSArray *array = [jsonData objectFromJSONData];
        
        if (self.pointsArray.count == 1) {
            
            NSArray *array = self.pointsArray[0];
            BMKSportNode *sportNode = [[BMKSportNode alloc] init];
            
            CLLocationCoordinate2D GPSCoor = CLLocationCoordinate2DMake([array[1] doubleValue], [array[2] doubleValue]);
            
            NSDictionary *GPSDic = BMKConvertBaiduCoorFrom(GPSCoor, BMK_COORDTYPE_GPS);
            NSString *xstr=[GPSDic objectForKey:@"x"];
            NSString *ystr=[GPSDic objectForKey:@"y"];
            NSData *xdata=[[NSData alloc] initWithBase64EncodedString:xstr options:0];
            NSData *ydata=[[NSData alloc] initWithBase64EncodedString:ystr options:0];
            NSString *xlat=[[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
            NSString *ylng=[[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
            GPSCoor.latitude=[xlat doubleValue];
            GPSCoor.longitude=[ylng doubleValue];
            
            sportNode.coordinate = GPSCoor;
            NSString *timeStamp = [NSString stringWithFormat:@"%@",array[0]];
            sportNode.currentTime = [TimestampModel getLocationTime:timeStamp];
            sportNode.angle = [array[4] doubleValue];
            sportNode.speed = [array[3] doubleValue];
            sportNode.timestamp = timeStamp;
            [sportNodes addObject:sportNode];
            
            
        }else{
            
            for (int i = 0;i < self.pointsArray.count;i++) {
                
                NSArray *array = self.pointsArray[i];
                NSArray *formArray;
                if (i>0) {
                    formArray = self.pointsArray[i-1];
                }
                BMKSportNode *sportNode = [[BMKSportNode alloc] init];
                
                 CLLocationCoordinate2D GPSCoor = CLLocationCoordinate2DMake([array[1] doubleValue], [array[2] doubleValue]);
                
                NSDictionary *GPSDic = BMKConvertBaiduCoorFrom(GPSCoor, BMK_COORDTYPE_GPS);
                NSString *xstr=[GPSDic objectForKey:@"x"];
                NSString *ystr=[GPSDic objectForKey:@"y"];
                NSData *xdata=[[NSData alloc] initWithBase64EncodedString:xstr options:0];
                NSData *ydata=[[NSData alloc] initWithBase64EncodedString:ystr options:0];
                NSString *xlat=[[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
                NSString *ylng=[[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
                GPSCoor.latitude=[xlat doubleValue];
                GPSCoor.longitude=[ylng doubleValue];
                
                sportNode.coordinate = GPSCoor;
                
                sportNode.angle = [array[4] doubleValue];
                sportNode.speed = [array[3] doubleValue];
                NSString *timeStamp = [NSString stringWithFormat:@"%@",array[0]];
                NSString *formTimestamp = [NSString stringWithFormat:@"%@",formArray[0]];
                sportNode.currentTime = [TimestampModel getLocationTime:timeStamp];
                sportNode.timestamp = timeStamp;
                [sportNodes addObject:sportNode];
                
//                添加停车点
                long long time1 = [formTimestamp longLongValue];
                long long time2 = [timeStamp longLongValue];
                
                long long timeInterval = time2/1000 - time1/1000;
//                NSLog(@"%lld",timeInterval);
                
                if (timeInterval > 180) {
                    
                    BMKPointAnnotation *parkPoint = [[BMKPointAnnotation alloc]init];
                    parkPoint.coordinate = GPSCoor;
                    [self.parkPointsArray addObject:parkPoint];
                }
            }
        }
        
    }
    
    sportNodeNum = sportNodes.count;
    self.progressSlider.maximumValue = sportNodeNum;
    NSLog(@"总点数>>>%ld",(long)sportNodes.count);
    
    
}

//开始
- (void)start {
    
    
    CLLocationCoordinate2D paths[sportNodeNum];
    for (NSInteger i = 0; i < sportNodeNum; i++) {
        BMKSportNode *node = sportNodes[i];
        paths[i] = node.coordinate;
    }
    
//    画线
    [self.mapView removeOverlay:pathPloyline];
    pathPloyline = [BMKPolyline polylineWithCoordinates:paths count:sportNodeNum];
    [self.mapView addOverlay:pathPloyline];
    

//    设置中心点
    self.mapView.centerCoordinate = paths[0];
    
    [self.mapView removeAnnotation:sportAnnotation];
    sportAnnotationView = nil;
    sportAnnotation = [[BMKPointAnnotation alloc]init];
    sportAnnotation.coordinate = paths[0];
    
//    sportAnnotation.title = @"车辆位置";
    [self.mapView addAnnotation:sportAnnotation];
    
    
//    绘制停车点
    [self.mapView removeAnnotations:self.parkPointsArray];
    [self.mapView addAnnotations:self.parkPointsArray];
    
    
    isAnimate = YES;
    
}

//runing
- (void)running {
    
    
    if (self.playButton.selected == NO) {
        
        BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
        NSString *imeiNo = [NSString stringWithFormat:@"%@",self.imeiNo];
        NSString *speed = [NSString stringWithFormat:@"%.fkm/h",node.speed];
        NSString *direction = [self getDirectionWithAngle:node.angle];
        NSString *currentTime = [TimestampModel getHistoryTime:node.timestamp];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@",currentTime];
        self.addressLabel.text = [NSString stringWithFormat:@"设备号:%@",imeiNo];
        self.speedLabel.text = speed;
        
        sportAnnotation.title = [NSString stringWithFormat:@"时间:%@,速度:%@,%@",node.currentTime,speed,direction];
        
        return ;
        
    }else if (currentIndex == sportNodes.count){
        
        NSLog(@"结束1");
        currentIndex = 0;
        self.playButton.selected = NO;

        return ;
    }
    
    BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
    sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle*M_PI/180);

    CGFloat carSpe = self.carSpeed;
    CGFloat carSpeed = carSpe/100.0;
    NSLog(@"%f",carSpeed);
    [UIView animateWithDuration:carSpeed animations:^{
        
//        NSLog(@"当前点>>>%ld",currentIndex);
        float currentInx = currentIndex;
//        float totalNum = sportNodes.count;
        self.progressSlider.value = currentInx;
//        NSLog(@"%f",self.progressSlider.value);
        
        NSString *imeiNo = [NSString stringWithFormat:@"%@",self.imeiNo];
        NSString *speed = [NSString stringWithFormat:@"%.fkm/h",node.speed];
        NSString *direction = [self getDirectionWithAngle:node.angle];
        NSString *currentTime = [TimestampModel getHistoryTime:node.timestamp];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@",currentTime];
        self.addressLabel.text = [NSString stringWithFormat:@"设备号:%@",imeiNo];
        self.speedLabel.text = speed;
        
        sportAnnotation.title = [NSString stringWithFormat:@"时间:%@,速度:%@,%@",node.currentTime,speed,direction];
        
        BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];

//        点移动
        sportAnnotation.coordinate = node.coordinate;
//        每隔10个点移动一次
        BOOL isTwenty = !(currentIndex%10);
        if (isTwenty) {
            [self.mapView setCenterCoordinate:node.coordinate animated:YES];
        }
        
//        二次划线
        self.isFirstLine = YES;
        
        [self.secondLineArray addObject:node];
        
        CLLocationCoordinate2D paths[self.secondLineArray.count];
        for (NSInteger i = 0; i < self.secondLineArray.count; i++) {
            BMKSportNode *secondNode = self.secondLineArray[i];
            paths[i] = secondNode.coordinate;
        }
        
        [self.mapView removeOverlay:self.secondPolyLine];
        self.secondPolyLine = [BMKPolyline polylineWithCoordinates:paths count:self.secondLineArray.count];
        [self.mapView addOverlay:self.secondPolyLine];
        
        currentIndex++;
        
    } completion:^(BOOL finished) {
        
        if (isAnimate&&currentIndex <= sportNodeNum) {
            [self running];
        }else{
            NSLog(@"结束2");
        }
        
    }];
 
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
//    [self start];
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        
        self.polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];

        self.polylineView.strokeColor = self.isFirstLine ? [[UIColor colorWithHexStr:@"#00FF00"] colorWithAlphaComponent:1.0]:[[UIColor colorWithHexStr:@"#a139e7"] colorWithAlphaComponent:0.7];
        self.polylineView.lineWidth = 3.0;
        
        return self.polylineView;
    }
    return nil;
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if (sportAnnotationView == nil) {
        
        sportAnnotationView = [[SportAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sportsAnnotation"];
        
        sportAnnotationView.draggable = NO;
        BMKSportNode *node = [sportNodes firstObject];
        sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle*M_PI/180);
        [sportAnnotationView setSelected:YES animated:YES];
        
        return sportAnnotationView;
        
    }else if([annotation isKindOfClass:[BMKPointAnnotation class]]){
        
        BMKPinAnnotationView *parkPoint = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"parkAnnotation"];
        parkPoint.animatesDrop = NO;
        parkPoint.image = [UIImage imageNamed:@"GPS_Park"];

        return parkPoint;
    }
    
    return nil;
}

#pragma mark - 大头针点击事件
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
        NSLog(@"点到了");
    }
    
    for (int i = 0; i < self.parkPointsArray.count; i++) {
        
        BMKPointAnnotation *parkPoint = self.parkPointsArray[i];
        
        if (view.annotation.coordinate.latitude == parkPoint.coordinate.latitude) {
//            NSLog(@"停车点>>>%f,%f",view.annotation.coordinate.latitude,view.annotation.coordinate.latitude);
        }
        
    }
    
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    [self running];
}

#pragma mark - geoDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSLog(@"%@",result.address);
        
        if (result.address) {
            [self.geoArray addObject:result.address];
        }
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
    
}

#pragma mark - 定位
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"这个 %@",userLocation.heading);
    //    [self.mapView updateLocationData:userLocation];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    NSLog(@"当前的坐标是:%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    self.lat2=userLocation.location.coordinate.latitude;
    //    self.lon2=userLocation.location.coordinate.longitude;
    
    [_mapView updateLocationData:userLocation]; //更新地图上的位置
    
    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    
    [self.locService stopUpdatingLocation];
}

#pragma mark - 创建进度条
-(void)createSlider
{
    
//    底部view
    self.progressView = [[UIView alloc]initWithFrame:CGRectMake(10, kScreen_H-90*Scale-15, kScreen_W-20, 90*Scale)];
    self.progressView.backgroundColor = [UIColor colorWithHexStr:@"#ffffff"];
    self.progressView.clipsToBounds = YES;
    [self.view addSubview:self.progressView];
    
    
//    播放按钮
    self.playButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 55*Scale, 30*Scale, 30*Scale)];
    [self.playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"icon_zanting"] forState:UIControlStateSelected];
    self.playButton.tintColor = [UIColor orangeColor];
    [self.playButton addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressView addSubview:self.playButton];
    
    
//    播放进度条
    self.progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(45*Scale, 55*Scale, kScreen_W-85*Scale, 30*Scale)];
//    self.progressSlider.maximumValue = 100;
    self.progressSlider.minimumValue = 0;
    self.progressSlider.tintColor = [UIColor colorWithHexStr:@"#1383ff"];
    [self.progressSlider addTarget:self
                       action:@selector(progressChange:) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self action:@selector(endClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(beginClick:) forControlEvents:UIControlEventTouchDown];
    [self.progressView addSubview:self.progressSlider];
    
    
//    车牌号
    self.vehicleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10*Scale, 150*Scale, 20*Scale)];
    self.vehicleLabel.text = self.vehicleNo;
    self.vehicleLabel.textColor = [UIColor colorWithHexStr:@"#222222"];
    self.vehicleLabel.font = [UIFont systemFontOfSize:15*Scale weight:UIFontWeightRegular];
    [self.progressView addSubview:self.vehicleLabel];
    
//    地址
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30*Scale, 200*Scale, 30*Scale)];
    self.addressLabel.textColor = [UIColor colorWithHexStr:@"#3b3b3b"];
    self.addressLabel.font = [UIFont systemFontOfSize:12*Scale weight:UIFontWeightRegular];
    self.addressLabel.numberOfLines = 0;
    [self.progressView addSubview:self.addressLabel];
    
//    时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:14*Scale weight:UIFontWeightRegular];
    self.timeLabel.textColor = [UIColor colorWithHexStr:@"#5b5b5b"];
//    self.timeLabel.text = @"2018-12-12 12:00:00";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.progressView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(10*Scale);
        make.width.offset(160*Scale);
        make.height.offset(20*Scale);
    }];
    
//    速度
    self.speedLabel = [[UILabel alloc]init];
    self.speedLabel.textAlignment = NSTextAlignmentRight;
//    self.speedLabel.text = @"40km/小时";
    self.speedLabel.font = [UIFont systemFontOfSize:13*Scale weight:UIFontWeightRegular];
    self.speedLabel.textColor = [UIColor colorWithHexStr:@"#999999"];
    [self.progressView addSubview:self.speedLabel];
    [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.addressLabel.mas_centerY).offset(0);
        make.width.offset(100*Scale);
        make.height.offset(30*Scale);
    }];
    
    
//    调节速度的view
    self.speedView = [[UIView alloc]initWithFrame:CGRectMake(kScreen_W-15-105*Scale, kScreen_H-130*Scale-15, 105*Scale, 25*Scale)];
    self.speedView.backgroundColor = [UIColor colorWithHexStr:@"#FF8043"];
    self.speedView.layer.masksToBounds = YES;
    self.speedView.layer.cornerRadius = 12.5*Scale;
    [self.view addSubview:self.speedView];
    
    
//    播放速度
    self.playSpeedLabel = [[UILabel alloc]init];
    self.playSpeedLabel.text = @"<  1倍速  >";
    self.playSpeedLabel.font = [UIFont systemFontOfSize:12*Scale weight:UIFontWeightRegular];
    self.playSpeedLabel.textAlignment = NSTextAlignmentCenter;
    self.playSpeedLabel.textColor = [UIColor whiteColor];
    [self.speedView addSubview:self.playSpeedLabel];
    [self.playSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.speedView.mas_centerX).offset(0);
        make.centerY.equalTo(self.speedView.mas_centerY).offset(0);
        make.width.offset(100*Scale);
        make.height.offset(25*Scale);
    }];
    
//    减速
    UIButton *slowButton = [[UIButton alloc]init];
    [slowButton setImage:[UIImage imageNamed:@"btn_slower"] forState:UIControlStateNormal];
    [slowButton addTarget:self action:@selector(slowClick) forControlEvents:UIControlEventTouchUpInside];
    [self.speedView addSubview:slowButton];
    [slowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.speedView.mas_centerX).offset(-20*Scale);
        make.centerY.equalTo(self.speedView.mas_centerY).offset(0);
        make.width.offset(30*Scale);
        make.height.offset(25*Scale);
    }];
    
//    加速
    UIButton *fastButton = [[UIButton alloc]init];
    [fastButton setImage:[UIImage imageNamed:@"btn_faster"] forState:UIControlStateNormal];
    [fastButton addTarget:self action:@selector(fastClick) forControlEvents:UIControlEventTouchUpInside];
    [self.speedView addSubview:fastButton];
    [fastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speedView.mas_centerX).offset(20*Scale);
        make.centerY.equalTo(self.speedView.mas_centerY).offset(0);
        make.width.offset(30*Scale);
        make.height.offset(25*Scale);
    }];
    

    
    
}

#pragma mark - 播放/暂停
-(void)playClick:(UIButton *)btn
{
    
    if (sportNodes.count == 0 || sportNodes.count == 1){
        [MBProgressHUD showMessag:@"暂无轨迹可播放" toView:kWindow andShowTime:1];
        return ;
    }
    self.playButton.selected = !self.playButton.selected;
    if (self.playButton.selected == YES) {
        if (currentIndex == 0) {
            [self.mapView removeOverlay:self.secondPolyLine];
            [self.secondLineArray removeAllObjects];
        }
        [self running];
    }
    NSLog(@"%d",self.playButton.selected);
}

#pragma mark - 拖动进度条
-(void)progressChange:(UISlider *)slider
{
//    NSLog(@"当前进度>>>%f",slider.value);
}

#pragma mark - 结束拖动
-(void)endClick:(UISlider *)slider
{
    
    
    self.playButton.selected = YES;
    
    NSInteger currentIdx = slider.value;
    
    if (sportNodeNum == 0) {
        
        [MBProgressHUD showMessag:@"暂无轨迹可播放" toView:kWindow andShowTime:1];
        
        return ;
    }
    
    currentIndex = currentIdx % sportNodeNum;
    NSLog(@"拖动结束的点>>>%ld",(long)currentIndex);
    if (currentIndex == 0 ) {
        
        NSLog(@"超出");
        
    }else{
        
        self.secondLineArray = [NSMutableArray arrayWithArray:[sportNodes subarrayWithRange:NSMakeRange(0, currentIndex-1)]];
        [self running];
        
    }
    
    
}

#pragma mark - 开始拖动
-(void)beginClick:(UISlider *)slider
{
    
    self.playButton.selected = NO;
    
}

#pragma mark - 调节快慢
-(void)speedChange:(UISlider *)slider
{
    NSLog(@"当前速度>>>%f",slider.value);
    self.carSpeed = slider.maximumValue - slider.value;
}

#pragma mark - 播放速度减小
-(void)slowClick
{
    
    if (self.carSpeed == 61) {
        
        NSLog(@"不能再减");
        
    }else{
        
        self.carSpeed = self.carSpeed + 30;
        NSLog(@"%d",self.carSpeed);
        self.playSpeedLabel.text = [NSString stringWithFormat:@"<  %d倍速  >",(3- (self.carSpeed - 1)/30)];
    }
    
    
}

#pragma mark - 播放速度增加
-(void)fastClick
{
    
    
    if (self.carSpeed == 1) {
        
        NSLog(@"不能再加");
        
    }else{
        
        self.carSpeed =  self.carSpeed - 30;
        NSLog(@"%d",self.carSpeed);
        self.playSpeedLabel.text = [NSString stringWithFormat:@"<  %d倍速  >",(3 -(self.carSpeed - 1)/30)];
    }
    
    
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



#pragma mark - 加载选择界面
-(void)loadChoiceController
{
    self.playButton.selected = NO;
    self.isFirstLine = NO;
    
    [self.timer invalidate];
    self.timer = nil;
    
    typeof(self) weakSelf = self;
    GPS_ChoiceViewController *choiceVC = [[GPS_ChoiceViewController alloc]init];
    choiceVC.modalPresentationStyle = UIModalPresentationFullScreen;
    choiceVC.vehicleNo = self.vehicleNo;
    choiceVC.pathBlock = ^(NSInteger index,NSString *startTime,NSString *endTime) {
        
        NSLog(@"%ld--%@--%@",(long)index,startTime,endTime);
        self.timeType = index;
        
        if (index == 6) {
            
//            点击取消，开启定位
            [weakSelf.locService startUpdatingLocation];
            
        }
        else{
            
            self.addressLabel.text = @"";
            self.pageIndex = 1;
            self.progressSlider.value = 0;
            currentIndex = 0;
            [self.mapView removeOverlay:self.secondPolyLine];
            [self.secondLineArray removeAllObjects];
            self.parkButton.selected = YES;
            sportAnnotationView = nil;
            [self.mapView removeAnnotation:sportAnnotation];
            [self.mapView removeAnnotations:self.parkPointsArray];
            [self.parkPointsArray removeAllObjects];
            [sportNodes removeAllObjects];
            self.startTime = startTime;
            self.endTime = endTime;
            [weakSelf getHistoryPointWithType:index];
        }
        
    };
    
    [self addChildViewController:choiceVC];
    [self.view addSubview:choiceVC.view];
    [self.view bringSubviewToFront:choiceVC.view];
    
}

#pragma mark - 显示停车点
-(void)stopClick:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    
    if (btn.selected == YES) {
        
        [self.mapView addAnnotations:self.parkPointsArray];
    }else{
        [self.mapView removeAnnotations:self.parkPointsArray];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    self.searcher.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
    self.searcher.delegate = nil;
    isAnimate = NO;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
