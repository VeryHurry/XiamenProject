//
//  SQTrackDetailViewController.m
//  XiamenProject
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQTrackDetailViewController.h"
#import "JSONKit.h"
#import "MacroDefinition.h"
#import "SQTrackMessageView.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

// 运动结点信息类
@interface BMKTrackModel : NSObject

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

@implementation BMKTrackModel

@synthesize coordinate = _coordinate;
@synthesize angle = _angle;
@synthesize distance = _distance;
@synthesize speed = _speed;
@synthesize currentTime = _currentTime;
@synthesize timestamp = _timestamp;

@end

// 自定义BMKAnnotationView，用于显示运动者
@interface CustomAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomAnnotationView

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

@interface SQTrackDetailViewController ()<BMKMapViewDelegate,BMKBusLineSearchDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKSuggestionSearchDelegate,BMKRouteSearchDelegate,BMKLocationManagerDelegate>
{
    BMKPolyline *pathPloyline;
    BMKPointAnnotation *sportAnnotation;
    CustomAnnotationView *sportAnnotationView;
    
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

@implementation SQTrackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"行程结束";
    self.isBack = YES;
    sportNodes = [[NSMutableArray alloc] init];
    self.parkPointsArray = [[NSMutableArray alloc]init];
    [self createUI];
    
    NSArray *arr = @[@{@"longitudeBD":@"119.31295748382206",@"latitudeBD":@"26.06261871527765"},@{@"longitudeBD":@"118.05354479409809",@"latitudeBD":@"24.49218137283779"}];
//    [self drawHistoryTrackWithPoints:arr];
    [self getMessage];
    
    SQTrackMessageView *trackView = [[SQTrackMessageView alloc]initWithFrame:kFrame(0, kNav_H, kScreen_W, 275) model:self.model];
    [self.view addSubview:trackView];
}

- (void)createUI
{
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,kNav_H, kScreen_W, kScreen_H-kNav_H)];
    self.mapView.delegate = self;
    self.mapView.backgroundColor = [UIColor clearColor];
    [self.mapView setMapType:BMKMapTypeStandard];
    //    [self.mapView setTrafficEnabled:YES];
    [self.mapView setBuildingsEnabled:YES];
    [self.mapView setShowMapPoi:YES];
    [self.mapView setZoomLevel:16.0];
    //    self.mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    
    self.mapView.rotateEnabled = YES; //设置是否可以旋转
    
    //    初始位置
    [self.view addSubview:self.mapView];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
    //    _mapView.showsUserLocation = YES;//显示定位图层定位罗盘模式
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
    //    _mapView.showsUserLocation = YES;//显示定位图层定位罗盘模式
    
    
    //  初始化BMKLocationService
    self.locService = [[BMKLocationManager alloc]init];
    self.locService.desiredAccuracy = kCLLocationAccuracyBest;
    self.locService.distanceFilter = kCLDistanceFilterNone;
    
    //    开始定位
    [self.locService startUpdatingLocation];
}


- (void)start {
    
    
    CLLocationCoordinate2D paths[sportNodeNum];
    for (NSInteger i = 0; i < sportNodeNum; i++) {
        BMKTrackModel *node = sportNodes[i];
        paths[i] = node.coordinate;
    }
    
    //    画线
    [self.mapView removeOverlay:pathPloyline];
    pathPloyline = [BMKPolyline polylineWithCoordinates:paths count:sportNodeNum];
    [self.mapView addOverlay:pathPloyline];
    
    
    //    设置中心点
    self.mapView.centerCoordinate = paths[0];
    
    // 起点annotation
    BMKPointAnnotation *startAnnotation = [[BMKPointAnnotation alloc] init];
    startAnnotation.coordinate = paths[0];
    startAnnotation.title = @"起点";
    // 终点annotation
    BMKPointAnnotation *endAnnotation = [[BMKPointAnnotation alloc] init];
    endAnnotation.coordinate = paths[sportNodeNum - 1];
    endAnnotation.title = @"终点";
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:endAnnotation];
    
}


#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
//        [self start];
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
    BMKAnnotationView *view = nil;
    if ([annotation.title isEqualToString: @"起点"]) {
        static NSString *historyTrackStartPositionAnnotationViewID = @"historyTrackStartPositionAnnotationViewID";
        view = [mapView dequeueReusableAnnotationViewWithIdentifier:historyTrackStartPositionAnnotationViewID];
        if (view == nil) {
            view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:historyTrackStartPositionAnnotationViewID];
            view.image = [UIImage imageNamed:@"trip_ic_star"];
        }
        
    }else if([annotation.title isEqualToString: @"终点"]){
        
        static NSString *historyTrackEndPositionAnnotationViewID = @"historyTrackEndPositionAnnotationViewID";
        view = [mapView dequeueReusableAnnotationViewWithIdentifier:historyTrackEndPositionAnnotationViewID];
        if (view == nil) {
            view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:historyTrackEndPositionAnnotationViewID];
            view.image = [UIImage imageNamed:@"trip_ic_end"];
        }
    }
    
    return view;
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



//
//- (void)drawHistoryTrackWithPoints:(NSArray *)points {
//    // line代表轨迹
//
//    NSLog(@"%@",points);
//
//    CLLocationCoordinate2D coors[points.count];
//    NSInteger count = 0;
//    for (size_t i = 0; i < points.count; i++) {
////        CLLocationCoordinate2D p = CLLocationCoordinate2DMake([points[i][@"latitudeBD"] doubleValue], [points[i][@"longitudeBD"] doubleValue]);
//        count++;
//        coors[i] = CLLocationCoordinate2DMake([points[i][@"latitudeBD"] doubleValue], [points[i][@"longitudeBD"] doubleValue]);
//    }
//    BMKPolyline *line = [BMKPolyline polylineWithCoordinates:coors count:count];
//    // 起点annotation
//    BMKPointAnnotation *startAnnotation = [[BMKPointAnnotation alloc] init];
//    startAnnotation.coordinate = coors[0];
//    startAnnotation.title = @"起点";
//    // 终点annotation
//    BMKPointAnnotation *endAnnotation = [[BMKPointAnnotation alloc] init];
//    endAnnotation.coordinate = coors[count - 1];
//    endAnnotation.title = @"终点";
//
//
//
//    [self.mapView removeOverlays:self.mapView.overlays];
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    [self mapViewFitForCoordinates:points];
//    [self.mapView addOverlay:line];
//    [self.mapView addAnnotation:startAnnotation];
//    [self.mapView addAnnotation:endAnnotation];
//
//}
//设置起点图片，和最后一个点的位置
//-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
//    BMKAnnotationView *view = nil;
//    if ([annotation.title isEqualToString:kStartPositionTitle]) {
//        static NSString *historyTrackStartPositionAnnotationViewID = @"historyTrackStartPositionAnnotationViewID";
//        view = [mapView dequeueReusableAnnotationViewWithIdentifier:historyTrackStartPositionAnnotationViewID];
//        if (view == nil) {
//            view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:historyTrackStartPositionAnnotationViewID];
//            view.image = [UIImage imageNamed:@"icon_start"];
//        }
//    } else if ([annotation.title isEqualToString:kEndPositionTitle]) {
//        static NSString *historyTrackEndPositionAnnotationViewID = @"historyTrackEndPositionAnnotationViewID";
//        view = [mapView dequeueReusableAnnotationViewWithIdentifier:historyTrackEndPositionAnnotationViewID];
//        if (view == nil) {
//            view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:historyTrackEndPositionAnnotationViewID];
//            view.image = [UIImage imageNamed:@"icon_end"];
//        }
//    } else if ([annotation.title isEqualToString:kArrowTitle]) {
//        static NSString *historyTrackArrorAnnotationViewID = @"historyTrackArrorAnnotationViewID";
//        view = [mapView dequeueReusableAnnotationViewWithIdentifier:historyTrackArrorAnnotationViewID];
//        if (view == nil) {
//            self.arrowAnnotationView = [[GYArrowAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:historyTrackArrorAnnotationViewID];
//            self.arrowAnnotationView.imageView.transform = CGAffineTransformMakeRotation(((GYHistoryTrackPoint *)[self.historyPoints firstObject]).direction);
//            view = self.arrowAnnotationView;
//        }
//    }
//    return view;
//}

//下面就是轨迹线的粗细颜色
//-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
//
//
//    if ([overlay isKindOfClass:[BMKPolyline class]]) {
//        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
//        polylineView.strokeColor = kBlue;
//        polylineView.lineWidth = 2.0;
//        return polylineView;
//    }
//    return nil;
//}
//-(void)mapViewFitForCoordinates:(NSArray *)points {
//    double minLat = 90.0;
//    double maxLat = -90.0;
//    double minLon = 180.0;
//    double maxLon = -180.0;
//
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) * 0.5, (minLon + maxLon) * 0.5);
//    BMKCoordinateSpan span;
//    span.latitudeDelta = 1.2*((maxLat - minLat) + 0.01);
//    span.longitudeDelta = 1.2 *((maxLon - minLon) + 0.01);
//    BMKCoordinateRegion region;
//    region.center = center;
//    region.span = span;
//    [self.mapView setRegion:region animated:YES];
//}

//初始化轨迹点
- (void)initSportNodes {
    
    //读取数据
    //    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport_path" ofType:@"json"]];
    
    if (self.pointsArray) {
        //        NSArray *array = [jsonData objectFromJSONData];
        
        if (self.pointsArray.count == 1) {
            
            NSDictionary *dic = self.pointsArray[0];
            BMKTrackModel *sportNode = [[BMKTrackModel alloc] init];
            
            CLLocationCoordinate2D GPSCoor = CLLocationCoordinate2DMake([dic[@"latitudeBD"] doubleValue], [dic[@"longitudeBD"] doubleValue]);
            
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
            [sportNodes addObject:sportNode];
        }else{
            
            for (int i = 0;i < self.pointsArray.count;i++) {
                
                NSDictionary *dic = self.pointsArray[i];
                NSDictionary *formDic;
                if (i>0) {
                    formDic = self.pointsArray[i-1];
                }
                BMKTrackModel *sportNode = [[BMKTrackModel alloc] init];
                
                CLLocationCoordinate2D GPSCoor = CLLocationCoordinate2DMake([dic[@"latitudeBD"] doubleValue], [dic[@"longitudeBD"] doubleValue]);
                
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
                [sportNodes addObject:sportNode];
                
              
                    
                BMKPointAnnotation *parkPoint = [[BMKPointAnnotation alloc]init];
                parkPoint.coordinate = GPSCoor;
                [self.parkPointsArray addObject:parkPoint];
                
            }
        }
        
    }
    
    sportNodeNum = sportNodes.count;
    NSLog(@"总点数>>>%ld",(long)sportNodes.count);
    
    
}


#pragma mark - network
- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_TrackInfo) parameters:@{@"trackNo":self.model.trackNo} success:^(id success) {
            
            NSString *status = [NSString stringWithFormat:@"%@",success[@"status"]];
            if ([status isEqualToString:@"-1"]) {
                
                [MBProgressHUD showMessag:@"暂无轨迹" toView:kWindow andShowTime:1];
                
                [self.timer invalidate];
                self.timer = nil;
                
            }else{
                NSString *jsonString = [NSString stringWithFormat:@"%@",success[@"result"]];
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
               
//                if ([[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSDictionary class]]) {
                
                    NSLog(@"这是字典");
                    NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    
                    NSLog(@"%@",dataArr[0]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //                    初始化轨迹点
                        self.pointsArray = dataArr;
                        [self initSportNodes];
                        [self start];
                       
                    });
//                }
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
