//
//  SQMapViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/23.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQMapViewController.h"
#import "MacroDefinition.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
static NSString * const cellID = @"cellID";
static NSString * const cell2ID = @"cell2ID";
@interface SQMapViewController ()<BMKMapViewDelegate, BMKLocationManagerDelegate,BMKGeneralDelegate,BMKPoiSearchDelegate,BMKSuggestionSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView *_topbgView;
    NSString *_cityName;
    CLLocationCoordinate2D _pt;
    BOOL _isAutoMove;
    BMKPointAnnotation*_pointAnnotation;
}
@property (nonatomic, copy) XXNSArrayBlock block;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@property (nonatomic, strong) BMKPoiSearch *poiSearch;

@property (nonatomic, assign) NSInteger searchType;//搜索类型
@property (nonatomic, assign) NSInteger pageIndex;//翻页

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSArray *searchList;
@property (nonatomic, assign) NSIndexPath *selectIndex;//单选，当前选中的行
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UITextField *textView;

@end

@implementation SQMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.title = @"违规地址";
    self.pageIndex = 0;
    self.searchType = 0;
    [self createMapView];
    [self setupSearchView];
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex ++;
        [self searchNearByPageIndex:self.pageIndex];
    }];
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.searchTableView];
    
    //开启定位服务
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    
    //显示定位图层
    _mapView.showsUserLocation = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
}

- (void)selectAddress:(XXNSArrayBlock)block
{
    if (block) {
        self.block = block;
    }
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

- (void)searchNearByPageIndex:(NSInteger)pageIndex
{
    //初始化请求参数类BMKNearbySearchOption的实例
    BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc] init];
    //检索关键字，必选
    nearbyOption.keywords = @[@"房地产、金融、美食"];
    //检索中心点的经纬度，必选
    nearbyOption.location = CLLocationCoordinate2DMake(_pt.latitude, _pt.longitude);
    //检索半径，单位是米。
    nearbyOption.radius = 3000;
    
    //是否严格限定召回结果在设置检索半径范围内。默认值为false。
    nearbyOption.isRadiusLimit = NO;
    //POI检索结果详细程度
    //nearbyOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
    //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
    //nearbyOption.filter = filter;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    nearbyOption.pageIndex = self.pageIndex;
    nearbyOption.pageSize = 10;
    
    BOOL flag = [self.poiSearch poiSearchNearBy:nearbyOption];
    if (flag) {
        NSLog(@"POI周边检索成功");
    } else {
        NSLog(@"POI周边检索失败");
    }
}

- (void)searchCity:(NSInteger)pageIndex
{
    BMKPOICitySearchOption *cityOption = [[BMKPOICitySearchOption alloc] init];
    //检索关键字，必选。举例：小吃
    cityOption.keyword = @"房地产";
    //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
    cityOption.city = @"厦门市";
    //区域数据返回限制，可选，为YES时，仅返回city对应区域内数据
    cityOption.isCityLimit = YES;
    //POI检索结果详细程度
    //cityOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
    //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
    //cityOption.filter = filter;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    cityOption.pageIndex = 0;
    //单次召回POI数量，默认为10条记录，最大返回20条
    cityOption.pageSize = 15;
    
    BOOL flag = [self.poiSearch poiSearchInCity:cityOption];
    if (flag) {
        NSLog(@"POI周边检索成功");
    } else {
        NSLog(@"POI周边检索失败");
    }
}

- (void)addressNameTip:(NSString *)textName
{
    BMKSuggestionSearch *search = [[BMKSuggestionSearch alloc] init];
    search.delegate = self;
    BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
    option.cityname = @"厦门市";
    option.keyword  = textName;
    BOOL flag = [search suggestionSearch:option];
    if (flag) {
        NSLog(@"Sug检索发送成功");
    }  else  {
        NSLog(@"Sug检索发送失败");
    }
}

/**
 *返回suggestion搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:( BMKSuggestionSearchResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        self.searchList = result.suggestionList;
        self.maskView.hidden = NO;
        self.searchTableView.hidden = NO;
        
        [self.searchTableView reloadData];
        
        
        
        NSLog(@"aaa");
    }
    else {
        NSLog(@"检索失败");
    }
}

/*@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误码，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        if (self.pageIndex < poiResult.totalPageNum-1 ) {
            [self.dataList addObjectsFromArray:poiResult.poiInfoList];
            [self.tableView.mj_footer endRefreshing];
        }
        else if (self.pageIndex == poiResult.totalPageNum-1 ) {
            [self.dataList addObjectsFromArray:poiResult.poiInfoList];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        //        NSLog(@"检索结果返回成功：%@",poiResult.poiInfoList);
        
        [self.tableView reloadData];
        
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有歧义");
    } else {
        NSLog(@"其他检索结果错误码");
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
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
    _pt = location.location.coordinate;
    self.userLocation.location = location.location;
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
    _mapView.centerCoordinate = self.userLocation.location.coordinate;
    
    [self searchNearByPageIndex:self.pageIndex];
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.pinColor = BMKPinAnnotationColorRed;
        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
        return annotationView;
    }
    return nil;
}

#pragma mark - UITableViewDelegate && dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2) {
        return self.searchList.count;
    }
    else
        return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        BMKSuggestionInfo *model = self.searchList[indexPath.row];
        cell.textLabel.text = model.key;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell2ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        BMKPoiInfo *model = self.dataList[indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = model.address;
        
        if (self.selectIndex == indexPath) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2)
    {
        self.maskView.hidden = YES;
         _isAutoMove = YES;
        BMKSuggestionInfo *model = self.searchList[indexPath.row];
        [self.mapView setCenterCoordinate:model.location animated:YES];
        
        if (_pointAnnotation != nil) {
            //删除指定的单个点标记
            [_mapView removeAnnotation:_pointAnnotation];
        }
        _pointAnnotation= [[BMKPointAnnotation alloc]init];
        _pointAnnotation.coordinate= model.location;
        //    _pointAnnotation.title = [NSString stringWithFormat:@"%@%@%@%@",location.rgcData.city,location.rgcData.district,location.rgcData.street,location.rgcData.street];
        _pointAnnotation.title = [NSString stringWithFormat:@"%@",model.city];
        _pointAnnotation.subtitle = [NSString stringWithFormat:@"%@",model.key];
        [_mapView addAnnotation:_pointAnnotation];
        [_mapView selectAnnotation:_pointAnnotation animated:YES];
        self.searchTableView.hidden = YES;
        self.block(@[model.key]);
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        _isAutoMove = YES;
        BMKPoiInfo *model = self.dataList[indexPath.row];
        [self.mapView setCenterCoordinate:model.pt animated:YES];
        
        if (_pointAnnotation != nil) {
            //删除指定的单个点标记
            [_mapView removeAnnotation:_pointAnnotation];
        }
        _pointAnnotation= [[BMKPointAnnotation alloc]init];
        _pointAnnotation.coordinate= model.pt;
        //    _pointAnnotation.title = [NSString stringWithFormat:@"%@%@%@%@",location.rgcData.city,location.rgcData.district,location.rgcData.street,location.rgcData.street];
        _pointAnnotation.title = [NSString stringWithFormat:@"%@",model.city];
        _pointAnnotation.subtitle = [NSString stringWithFormat:@"%@",model.address];
        [_mapView addAnnotation:_pointAnnotation];
        [_mapView selectAnnotation:_pointAnnotation animated:YES];
        
        //之前选中的，取消选择
        UITableViewCell *celled = [tableView cellForRowAtIndexPath:self.selectIndex];
        celled.accessoryType = UITableViewCellAccessoryNone;
        //记录当前选中的位置索引
        self.selectIndex = indexPath;
        //当前选择的打勾
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.block(@[kString(model.address)]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - textField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        self.maskView.hidden = NO;
        self.searchTableView.hidden = NO;
    }
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.text.length > 0) {
        [self addressNameTip:theTextField.text];
    }
    else
    {
        self.searchList = @[];
        [self.searchTableView reloadData];
        self.searchTableView.hidden = YES;
    }
}




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
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kNav_H+45, kScreen_W, kScreen_W/375*180)];
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

- (BMKPoiSearch *)poiSearch
{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc]init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNav_H + kScreen_W/375*180+45, kScreen_W, kScreen_H - kNav_H - kScreen_W/375*180-45) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _searchTableView.tag = 1;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    
    return  _tableView;
}

- (UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNav_H+45, kScreen_W, kScale_H(250)) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.hidden = YES;
        _searchTableView.tag = 2;
        [_searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell2ID];
    }
    
    return  _searchTableView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:kFrame(0, kNav_H+45, kScreen_W, kScreen_H-kNav_H-45)];
        _maskView.backgroundColor = kBlack;
        _maskView.alpha = 0.5;
        _maskView.hidden = YES;
        [_maskView xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//            self.searchList = @[];
//            [self.searchTableView reloadData];
            self.maskView.hidden = YES;
            self.searchTableView.hidden = YES;
        }];
    
    }
    return _maskView;
}

- (void)setupSearchView {
    UIView *topView = [[UIView alloc]initWithFrame:kFrame(0, kNav_H, kScreen_W, 45)];
    topView.backgroundColor = kWhite;
    [self.view addSubview:topView];
    _topbgView = topView;
    
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = ColorWithHex(0xE5E5E5);
    searchView.layer.cornerRadius = 17;
    searchView.layer.masksToBounds = YES;
    [topView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(10);
        make.right.equalTo(topView).offset(-10);
        make.height.mas_equalTo(@34);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"厦门市";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = ColorWithHex(0x313131);
    [searchView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(searchView).offset(15);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"|";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label1.textColor = ColorWithHex(0xAAAAAA);
    
    [searchView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(label.mas_right).offset(15);
        make.width.mas_equalTo(2);
    }];
    
    _textView = [[UITextField alloc] init];
    _textView.placeholder = @"小区/写字楼/学校";
    _textView.delegate = self;
    [searchView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(label1.mas_right).offset(15);
        make.right.equalTo(searchView).offset(-15);
    }];
    
    [_textView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


- (NSArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

@end

