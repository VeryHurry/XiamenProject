//
//  SQHomeViewController.m
//  LeTu
//
//  Created by MacStudent on 2019/5/8.
//  Copyright © 2019 mtt. All rights reserved.
//

#import "SQHomeViewController.h"
#import "SQNoticeDetailViewController.h"
#import "SQLoginViewController.h"
#import "SQTestListViewController.h"
#import "SQViolationsViewController.h"
#import "SQScanViewController.h"
#import "SQViolationsFeedbackViewController.h"
#import "SQVehicleManagementViewController.h"
#import "SQLiveTrafficViewController.h"
#import "SQVehicleMessageViewController.h"
#import "ZKCycleScrollView.h"
#import "LXPageControl.h"
#import "RemoteImageCell.h"
#import "SQNoticeCell.h"
#import "MyVehicleModel.h"
#import "Masonry.h"
#import "MacroDefinition.h"
#import "SELUpdateAlert.h"

#define FIT_WIDTH(w) w * SCREEN_WIDTH / 375.f
static NSString *kRemoteCellId = @"RemoteImageCell";

@interface SQHomeViewController ()<ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *remotePathGroup;

@property (nonatomic, strong) NSArray *noticeArr, *bannerArr;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ZKCycleScrollView *cycleScrollView;
@property (nonatomic, strong) LXPageControl *pageControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *vehicleBtn;

@property (nonatomic, strong) NSDictionary *vehicleDic;//车辆信息
@property (nonatomic, assign) BOOL isBind;//是否扫码绑定
@property (nonatomic, assign) BOOL isUserBind;//是否绑定车辆
@property (nonatomic, strong) MyVehicleModel *model;

@end

@implementation SQHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self isLogin];
    //[kUserDefaults setObject:@"15259203981" forKey:@"mobile"];
    self.navigationController.navigationBarHidden = NO;
    [_cycleScrollView adjustWhenViewWillAppear];
    NSLog(@"----***************-----------%@",[kUserDefaults objectForKey:@"mobile"]);
    if ([kUserDefaults objectForKey:@"mobile"]&&!kIsEmptyStr([kUserDefaults objectForKey:@"mobile"]))
    {
        [self getMessage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getVersion];
    UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [customBtn setImage:[UIImage imageNamed:@"home_ic_scan"] forState:UIControlStateNormal];
    customBtn.titleLabel.font = Font(13);
    [customBtn setTitleColor:ColorWithHex(0x959595) forState:UIControlStateNormal];
    customBtn.enabled = NO;
    [customBtn addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    self.title = @"首页";
}

- (void)isLogin
{
    if (![UserDefaultsTool getBoolForKey:@"isLogin"]) {
        SQLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"login_sb"];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark - UI
- (void)createUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SQNoticeCell" bundle:nil] forCellReuseIdentifier:@"notice_cell"];
    [self.view addSubview:self.tableView];
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:_headView];
    
    [self.headView addSubview:({
        _scrollView = [[UIScrollView alloc] initWithFrame:kFrame(0, 0, kScreen_W, kScale_H(188))];
        _scrollView.contentSize = CGSizeMake(kScreen_W, kScale_H(188));
        _scrollView;
    })];
    
    CGFloat vehicleHeight;
    _vehicleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_isBind == YES) {
        _vehicleBtn.frame = kFrame(10, kScale_H(188)+5, kScreen_W-20, (kScreen_W-20)/(362/49));
        vehicleHeight = (kScreen_W-20)/(362/49)+15;
    }
    else
    {
        _vehicleBtn.frame = kFrame(10, kScale_H(188)+5, kScreen_W-20, 0);
        vehicleHeight = 0;
    }
    
    [_vehicleBtn setBackgroundImage:[UIImage imageNamed:@"bg_home2"] forState:UIControlStateNormal];
    [_vehicleBtn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        result *model = self.model.result[0];
        SQVehicleMessageViewController *vc = [SQVehicleMessageViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.cid = kStrNum(model.ID);
        vc.type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.headView addSubview:_vehicleBtn];
    
    UIImageView *img1 = [[UIImageView alloc]init];
    img1.image = [UIImage imageNamed:@"home_ic_car"];
    [_vehicleBtn addSubview:img1];
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.centerY.equalTo(self.vehicleBtn.mas_centerY).offset(0);
        make.width.offset(28*Scale);
        make.height.offset(20*Scale);
    }];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"您已绑定车俩";
    lab.textColor = kWhite;
    lab.font = Font(14*Scale);
    [_vehicleBtn addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img1.mas_right).offset(8);
        make.centerY.equalTo(self.vehicleBtn.mas_centerY).offset(0);
    }];
    
    UIImageView *img2 = [[UIImageView alloc]init];
    img2.image = [UIImage imageNamed:@"manage_ic_next"];
    [_vehicleBtn addSubview:img2];
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.centerY.equalTo(self.vehicleBtn.mas_centerY).offset(0);
        make.width.offset(6*Scale);
        make.height.offset(12*Scale);
    }];
    
    UILabel *lab1 = [[UILabel alloc]init];
    lab1.text = @"车况";
    lab1.textColor = kWhite;
    lab1.font = Font(12*Scale);
    [_vehicleBtn addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(img2.mas_left).offset(-9);
        make.centerY.equalTo(self.vehicleBtn.mas_centerY).offset(0);
    }];
    
    _menuView = [[UIView alloc]initWithFrame:kFrame(0, kScale_H(188)+vehicleHeight, kScreen_W, 175)];
    _menuView.backgroundColor = kWhite;
    [self.headView addSubview:_menuView];
    
    for (int i = 0; i < 6; i++) {
        
        UIButton *logoImageV = [[UIButton alloc]init];
        CGRect rect;
        if (i <3) {
            rect = CGRectMake(kScreen_W/3*i, 0, kScreen_W/3, 87);
        }
        else
        {
            rect = CGRectMake(kScreen_W/3*(i-3), 88, kScreen_W/3, 87);
        }
        logoImageV.frame = rect;
        logoImageV.tag = 10 + i;
        
        //        [logoImageV setImage:[UIImage imageNamed:self.imagesArray[i]] forState:UIControlStateNormal];
        [logoImageV addTarget:self action:@selector(gotoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:logoImageV];
        
        UIImageView *image = [[UIImageView alloc]init];
        image.center = CGPointMake(logoImageV.frame.size.width/2, logoImageV.frame.size.height/2-12);
        CGRect imageRect;
        if (i == 0) {
            imageRect = kFrame(0, 0, 22*Scale, 23*Scale);
        }
        else if (i == 1)
        {
            imageRect = kFrame(0, 0, 30*Scale, 22*Scale);
        }
        else if (i == 2)
        {
            imageRect = kFrame(0, 0, 21*Scale, 25*Scale);
        }
        else if (i == 3)
        {
            imageRect = kFrame(0, 0, 23*Scale, 22*Scale);
        }
        else if (i == 4)
        {
            imageRect = kFrame(0, 0, 21*Scale, 25*Scale);
        }
        else
        {
            imageRect = kFrame(0, 0, 23*Scale, 23*Scale);
        }
        image.bounds = imageRect;
        image.image = [UIImage imageNamed:self.imagesArray[i]];
        [logoImageV addSubview:image];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:11*Scale];
        titleLabel.textColor = [UIColor colorWithHexStr:@"#484848"];
        titleLabel.text = self.titleArray[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [logoImageV addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(image.mas_centerX).offset(0);
            make.bottom.equalTo(logoImageV.mas_bottom).offset(-14);
            make.width.offset(kScreen_W/3);
            make.height.offset(15*Scale);
        }];
    }
    
    for (int i = 1; i < 3; i++)
    {
        UILabel *line = [[UILabel alloc]initWithFrame:kFrame((kScreen_W-2)/3*i+(i-1)*1, 0, 1, 175)];
        line.backgroundColor = [UIColor colorWithHexStr:@"#E5E5E5"];
        [self.menuView addSubview:line];
    }
    UILabel *line = [[UILabel alloc]initWithFrame:kFrame(0, 87, kScreen_W, 1)];
    line.backgroundColor = [UIColor colorWithHexStr:@"#E5E5E5"];
    [self.menuView addSubview:line];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:kFrame(18, 175+ kScale_H(188)+8+vehicleHeight, 150, 16)];
    lbl.text = @"通知";
    lbl.font = [UIFont systemFontOfSize:12*Scale];
    lbl.textColor = Home_Text_Color;
    [self.headView addSubview:lbl];
    
    self.headView.frame = kFrame(0, kNav_H, kScreen_W, 175+kScale_H(188)+24+vehicleHeight);
    
    [self addCycleScrollView];
    [self setupPageControlView:self.bannerArr.count];
    
    self.tableView.tableHeaderView = self.headView;
}

- (void)addCycleScrollView
{
    [_scrollView addSubview:({
        _cycleScrollView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 10, kScreen_W, kScale_H(156))];
        _cycleScrollView.delegate = self;
        _cycleScrollView.dataSource = self;
        _cycleScrollView.hidesPageControl = YES;
        _cycleScrollView.itemSpacing = 12.f;
        _cycleScrollView.autoScroll = YES;
        _cycleScrollView.itemSize = CGSizeMake(kScreen_W - 50.f, _cycleScrollView.bounds.size.height);
        [_cycleScrollView registerCellClass:[RemoteImageCell class] forCellWithReuseIdentifier:kRemoteCellId];
        _cycleScrollView;
    })];
}


#pragma mark - 自定义pageControl
- (void)setupPageControlView:(NSInteger)page {
    LXPageControl *pageControl = [[LXPageControl alloc] init];
    pageControl.numberOfPages = page;
    pageControl.itemWidth = 15;
    pageControl.itemHeight = 4;
    pageControl.itemSpacing = 6;
    //    pageControl.selectedImage = ImageNamed(@"");
    //    pageControl.unselectedImage = ImageNamed(@"");
    pageControl.selectedColor =  ColorWithHex(0x0068B7);
    pageControl.unselectedColor =  ColorWithHex(0xDDDDDD);
    [self.headView addSubview:pageControl];
    
    CGSize itemSize = CGSizeMake(page*(pageControl.itemWidth+pageControl.itemSpacing), pageControl.itemHeight);
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-kScale_H(10));
        make.centerX.equalTo(self.headView);
        make.size.mas_equalTo(itemSize);
    }];
    
    [pageControl setupPageControl];
    
    self.pageControl = pageControl;
}


#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView
{
    return self.bannerArr.count;
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index
{
    RemoteImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kRemoteCellId forIndex:index];
    NSDictionary *dic = self.bannerArr[index];
    cell.imageURL = [NSURL URLWithString:dic[@"url"]];
    return cell;
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"selected index: %zd", index);
}

- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress
{
    self.pageControl.currentPage = self.cycleScrollView.pageIndex;
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.noticeArr[indexPath.row];
    SQNoticeDetailViewController *vc = [SQNoticeDetailViewController new];
    vc.cid = dic[@"id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SQNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notice_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.noticeArr[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noticeArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

#pragma mark - 扫一扫
-(void)scanClick
{
    
    SQScanViewController *scanningVc = [[SQScanViewController alloc]init];
    scanningVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:scanningVc animated:YES];
    
}

#pragma mark - 跳转到各项功能界面
-(void)gotoClick:(UIButton *)btn
{
    
    switch (btn.tag) {
        case 10:
        {
            //培训学习
            SQTestListViewController *vc = [[SQTestListViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        case 11:
        {
            if (self.isUserBind) {
                SQVehicleManagementViewController *vc = [[SQVehicleManagementViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.imeiNo = self.vehicleDic[@"imeiNo"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [MBProgressHUD showMessag:@"请先绑定车辆" toView:kWindow andShowTime:1.5];
            }
        }
            break;
            
        case 12:
        {
            //违章查询
            SQViolationsViewController *vc = [[SQViolationsViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 13:
        {
            //随手拍
            SQViolationsFeedbackViewController *vc = [[SQViolationsFeedbackViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 14:
        {
            if (self.isUserBind) {
                SQLiveTrafficViewController *vc = [[SQLiveTrafficViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.vehicleNo = self.vehicleDic[@"vehicleNo"];
                vc.imeiNo = self.vehicleDic[@"imeiNo"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [MBProgressHUD showMessag:@"请先绑定车辆" toView:kWindow andShowTime:1.5];
            }
        }
            break;
            
        case 15:
        {
            [MBProgressHUD showMessag:@"该功能正在努力开发中" toView:kWindow andShowTime:1];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Network

- (void)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [Base_AFN_Manager postUrl:IP_SPLICE(IP_GetVersion) parameters:@{@"type":@"2",@"appVersion":app_Version} success:^(id success) {
        if (!kIsEmptyObj(success)) {
            if (![kString(success[@"level"]) isEqualToString:@"1"]) {
                [SELUpdateAlert showUpdateAlertWithVersion:@"1.0.0" Descriptions:@[success[@"content"]] level:success[@"level"]];
            }
            
        }
    } failure_login:nil failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
}

- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_Home_Message) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"]} success:^(id success) {
            if (!kIsEmptyObj(success)) {
                self.noticeArr = success[@"noticeList"];
                self.bannerArr = success[@"bannerList"];
                [self getBindStatus];
                if ([success[@"bianding"] integerValue] == 1) {
                    self.isBind = YES;
                }
                else
                {
                    self.isBind = NO;
                }
                [self createUI];
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (void)getBindStatus
{
    
    [Base_AFN_Manager postUrl:IP_SPLICE(IP_BindStatus) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"],@"pageNum":@"1",@"pageSize":@"20"} success:^(id success) {
        self.model = [MyVehicleModel mj_objectWithKeyValues:success];
        if (self.model.total > 0) {
            self.isUserBind = YES;
            result *model = self.model.result[0];
            self.vehicleDic = @{@"imeiNo": model.imeiNo,@"vehicleNo": kIsEmptyStr(model.vehicleNo)? @" ":model.vehicleNo};
        }
        else
        {
            self.isUserBind = NO;
        }
        
        
    } failure_login:nil failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
    
}


#pragma mark - 懒加载
- (UITableView*)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)noticeArr
{
    if (!_noticeArr) {
        _noticeArr = [NSArray new];
    }
    return _noticeArr;
}

- (NSArray *)bannerArr
{
    if (!_bannerArr) {
        _bannerArr = [NSArray new];
    }
    return _bannerArr;
}

- (NSArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = @[@"home_ic_stydu",@"home_ic_clgl",@"home_ic_wfcx",
                         @"home_ic_ssp",@"home_ic_sslk",@"home_ic_jqlx"];
    }
    return _imagesArray;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"培训学习",@"车辆管理",@"违法查询",
                        @"随手拍",@"实时路况",@"禁骑路线"];
    }
    return _titleArray;
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




