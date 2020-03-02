//
//  SQStatisticalViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/19.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQStatisticalViewController.h"
#import "NXLineChartView.h"
#import "FSLineChart.h"
#import "PTHistogramView.h"
#import "MacroDefinition.h"
@interface SQStatisticalViewController ()

@property (nonatomic,strong)UIView *buttonView;
@property (nonatomic,strong)UIButton *selectedButton;
@property (nonatomic,strong)UIView *dataView;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)NSMutableArray *milesArray;
@property (nonatomic,strong)NXLineChartView *chartView;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)PTHistogramView *ptView;
@property (nonatomic,strong)UIView *YAxisView;
@property (nonatomic,strong)UILabel *startLabel;
@property (nonatomic,strong)UILabel *endLabel;
@property (nonatomic,copy)NSString *startDate;
@property (nonatomic,copy)NSString *endDate;
@property (nonatomic,copy)NSString *currentMonthStart;
@property (nonatomic,copy)NSString *currentMonthEnd;
@property (nonatomic,assign)BOOL isGoOn;
@property (nonatomic,copy)NSString *weekStart;
@property (nonatomic,copy)NSString *weekEnd;
@property (nonatomic,copy)NSString *currentWeekStart;
@property (nonatomic,copy)NSString *currentWeekEnd;
@property (nonatomic,assign)BOOL weekGoOn;

@end

@implementation SQStatisticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.view.backgroundColor = [UIColor colorWithHexStr:@"#f5f5f5"];
    self.title = @"里程统计";
    
    
    //    获取当日时间
    NSDate *dateToday = [NSDate date];
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"yyyy-MM"];
    NSString *currentMonth = [monthFormatter stringFromDate:dateToday];
    NSLog(@"当前年月>>>%@",currentMonth);
    //    根据当前年月获取月初和月末时间
    NSArray *dateArray = [self getMonthBeginAndEndWith:currentMonth];
    
    //    今天
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [dayFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dayFormatter stringFromDate:dateToday];
    
    self.startDate = dateArray[0];
    self.endDate = today;
    self.weekStart = [self getLastWeekDateWithCurrentDate:today];
    self.weekEnd = today;
    NSLog(@"一周：%@--%@",self.weekStart,self.weekEnd);
    
    [self getDataWithStartDate:dateArray[0] andEndDate:today];
    
    //    本月月初
    self.currentMonthStart = dateArray[0];
    self.currentMonthEnd = today;
    //    本周下周的第一天
    self.currentWeekStart = [self getLastWeekDateWithCurrentDate:today];
    self.currentWeekEnd = today;
    
    [self createUI];
    
    
}

#pragma mark - 主视图布局
-(void)createUI
{
    
    //    月/周切换按钮
    self.buttonView = [[UIView alloc]init];
    self.buttonView.clipsToBounds = YES;
    self.buttonView.center = CGPointMake(kScreen_W/2, kNav_H+35*Scale);
    self.buttonView.bounds = CGRectMake(0, 0, kScreen_W-40*Scale, 35*Scale);
    self.buttonView.backgroundColor = [UIColor whiteColor];
    self.buttonView.layer.masksToBounds = YES;
    self.buttonView.layer.cornerRadius = 17.5*Scale;
    [self.view addSubview:self.buttonView];
    
    
    NSArray *weeksArray = @[@"月",@"周"];
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(kScreen_W-40*Scale)/2, 0, (kScreen_W-40*Scale)/2, 35*Scale)];
        btn.tag = 10 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:17*Scale weight:UIFontWeightBold];
        [btn setTitle:weeksArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexStr:@"#222222"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexStr:@"#ffffff"] forState:UIControlStateSelected];
        if (i == 0) {
            
            btn.selected = YES;
            self.selectedButton = btn;
            btn.backgroundColor = [UIColor colorWithHexStr:@"#009eea"];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:btn];
        
    }
    
    //    数据view
    self.dataView = [[UIView alloc]init];
    self.dataView.backgroundColor = [UIColor whiteColor];
    self.dataView.layer.masksToBounds = YES;
    self.dataView.layer.cornerRadius = 10*Scale;
    [self.view addSubview:self.dataView];
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.equalTo(self.buttonView.mas_bottom).offset(20*Scale);
        make.height.offset(385*Scale);
    }];
    
    
    //    上个月
    UIButton *leftButton = [[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"lastmonth"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dataView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dataView.mas_left).offset(0);
        make.top.equalTo(self.dataView.mas_top).offset(5*Scale);
        make.width.offset(35*Scale);
        make.height.offset(35*Scale);
    }];
    
    
    //    下个月
    UIButton *rightButton = [[UIButton alloc]init];
    [rightButton setImage:[UIImage imageNamed:@"nextmonth"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dataView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dataView.mas_right).offset(0);
        make.top.equalTo(self.dataView.mas_top).offset(5*Scale);
        make.width.offset(35*Scale);
        make.height.offset(35*Scale);
    }];
    
    
    //    显示时间的label
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",self.startDate,self.endDate];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:15*Scale weight:UIFontWeightRegular];
    self.timeLabel.textColor = [UIColor colorWithHexStr:@"#009eea"];
    [self.dataView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftButton.mas_right).offset(0);
        make.right.equalTo(rightButton.mas_left).offset(0);
        make.top.equalTo(self.dataView.mas_top).offset(5*Scale);
        make.height.offset(35*Scale);
    }];
    
    
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        label.tag = 20 + i;
        label.textColor = [UIColor colorWithHexStr:@"#3b3b3b"];
        label.font = [UIFont systemFontOfSize:14*Scale weight:UIFontWeightRegular];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20*Scale);
            make.top.equalTo(self.dataView.mas_bottom).offset(25*Scale + i*30*Scale);
            make.width.offset(200*Scale);
            make.height.offset(30*Scale);
        }];
        
    }
    
    
    self.YAxisView = [[UIView alloc]init];
    self.YAxisView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.YAxisView];
    [self.YAxisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(self.dataView.mas_top).offset(70*Scale);
        make.width.offset(30*Scale);
        make.height.offset(285*Scale);
    }];
    
    
    NSArray *arrayY = @[@"50",@"100"];
    for (int i = 0; i < 2; i++) {
        
        UILabel *YLabel = [[UILabel alloc]init];
        YLabel.text = arrayY[i];
        YLabel.font = [UIFont systemFontOfSize:12*Scale weight:UIFontWeightLight];
        YLabel.textColor = [UIColor colorWithHexStr:@"#3b3b3b"];
        YLabel.textAlignment = NSTextAlignmentCenter;
        [self.YAxisView addSubview:YLabel];
        [YLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.bottom.offset(-90*Scale-i*100*Scale);
            make.width.offset(30*Scale);
            make.height.offset(20*Scale);
        }];
        
    }
    
    UIView *verticalLine = [[UIView alloc]init];
    verticalLine.backgroundColor = [UIColor colorWithHexStr:@"#cccccc"];
    [self.YAxisView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.width.offset(1.0);
        make.bottom.offset(0);
    }];
    
    
    //    每月的起始日期和结束日期
    self.startLabel = [[UILabel alloc]init];
    self.startLabel.textColor = [UIColor colorWithHexStr:@"#3b3b3b"];
    self.startLabel.font = [UIFont systemFontOfSize:10*Scale weight:UIFontWeightRegular];
    [self.view addSubview:self.startLabel];
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dataView.mas_left).offset(10*Scale);
        make.bottom.equalTo(self.dataView.mas_bottom).offset(-30*Scale);
        make.width.offset(60*Scale);
        make.height.offset(20*Scale);
    }];
    
    
    self.endLabel = [[UILabel alloc]init];
    self.endLabel.textColor = [UIColor colorWithHexStr:@"#3b3b3b"];
    self.endLabel.textAlignment = NSTextAlignmentRight;
    self.endLabel.font = [UIFont systemFontOfSize:10*Scale weight:UIFontWeightRegular];
    [self.view addSubview:self.endLabel];
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dataView.mas_right).offset(0);
        make.bottom.equalTo(self.dataView.mas_bottom).offset(-30*Scale);
        make.width.offset(60*Scale);
        make.height.offset(20*Scale);
    }];
}

#pragma mark - 获取数据
-(void)getDataWithStartDate:(NSString *)startDate andEndDate:(NSString *)endDate
{
    
    //    [MBProgressHUD show:@""];
    
    NSString *url = [NSString stringWithFormat:@"%@/tocs-member-app/letu/gps/new/getVehicleRecode",CARIP];
    
    NSString *imeiNo = [NSString stringWithFormat:@"%@",self.imeiNo];
    
    
    NSDictionary *parameters = @{@"imeiNo":imeiNo,@"startDate":startDate,@"endDate":endDate};
    
    [DataModel getDataWithURL:url parameters:parameters returnBlock:^(NSDictionary *dic) {
        
        //        [MBProgressHUD hideHUD];
        
        NSLog(@"骑行数据>>>%@",dic);
        
        NSArray *resultArray = [[NSArray alloc]initWithArray:dic[@"result"]];
        for (NSDictionary *dataDic in resultArray) {
            
            NSString *date = [NSString stringWithFormat:@"%@",dataDic[@"date"]];
            NSDateFormatter *formater1 = [[NSDateFormatter alloc]init];
            [formater1 setDateFormat:@"YYYY-MM-dd"];
            NSDate *date1 = [formater1 dateFromString:date];
            NSDateFormatter *formater2 = [[NSDateFormatter alloc]init];
            [formater2 setDateFormat:@"MM-dd"];
            NSString *dateStr = [formater2 stringFromDate:date1];
            
            NSString *mileage = [NSString stringWithFormat:@"%@",dataDic[@"mileage"]];
            
            [self.dateArray addObject:dateStr];
            [self.milesArray addObject:mileage];
            
        }
        
        
        self.startLabel.text = [NSString stringWithFormat:@"%@",self.dateArray.firstObject];
        self.endLabel.text = [NSString stringWithFormat:@"%@",self.dateArray.lastObject];
        
        
        if (self.selectedButton.tag == 10) {
            
            [self.dataView addSubview:self.chartView];
            
        }else{
            
            [self createBarViewWithDate:self.dateArray andMile:self.milesArray];
            
            self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",self.weekStart,self.weekEnd];
        }
        
        
        UILabel *label1 = (UILabel *)[self.view viewWithTag:20];
        UILabel *label2 = (UILabel *)[self.view viewWithTag:21];
        label2.text = [NSString stringWithFormat:@"车牌号  %@",self.vehicleNo];
        
        //        富文本
        NSString *aveMile = [NSString stringWithFormat:@"%@",dic[@"avg"]];
        NSString *str1 = [NSString stringWithFormat:@"平均值  %@  公里/天",aveMile];
        NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithString:str1];
        [atrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:24*Scale weight:UIFontWeightRegular]} range:NSMakeRange(5, aveMile.length)];
        label1.attributedText = atrStr;
        
    }];
    
}


#pragma mark - 创建折线图
- (NXLineChartView * )chartView{
    
    if (!_chartView) {
        
        _chartView = [[NXLineChartView alloc]init];
        _chartView.backgroundColor = [UIColor whiteColor];
        _chartView.frame = CGRectMake(0, 70*Scale, kScreen_W-20, 300*Scale);
        _chartView.lineChartXLabelArray = self.dateArray;
        _chartView.lineChartYLabelArray = @[@0,@50,@100];
        _chartView.LineChartDataArray  = self.milesArray;
        
        NSLog(@"X:%lu--Y:%lu",(unsigned long)self.dateArray.count,(unsigned long)self.milesArray.count);
        
    }
    return _chartView;
}

#pragma mark - 创建柱状图
-(void)createBarViewWithDate:(NSMutableArray *)dateArray andMile:(NSMutableArray *)mileArray
{
    
    
    [self.ptView removeFromSuperview];
    
    self.ptView = [[PTHistogramView alloc]initWithFrame:CGRectMake(0, 70*Scale, kScreen_W-20, 300*Scale) nameArray:dateArray countArray:mileArray];
    
    [self.dataView addSubview:self.ptView];
    
}

#pragma mark - 切换
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"%ld",(long)btn.tag);
    self.selectedButton.selected = NO;
    self.selectedButton.backgroundColor = [UIColor colorWithHexStr:@"#ffffff"];
    btn.selected = YES;
    self.selectedButton = btn;
    
    if (self.selectedButton.selected == YES) {
        
        self.selectedButton.backgroundColor = [UIColor colorWithHexStr:@"#009eea"];
        
    }else{
        
        self.selectedButton.backgroundColor = [UIColor colorWithHexStr:@"#ffffff"];
    }
    
    
    if (btn.tag == 10) {
        
        [self.dataView bringSubviewToFront:self.chartView];
        self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",self.startDate,self.endDate];
        self.startLabel.hidden = NO;
        self.endLabel.hidden = NO;
        self.ptView.hidden = YES;
        
    }else{
        
        [self.dateArray removeAllObjects];
        [self.milesArray removeAllObjects];
        
        [self getDataWithStartDate:self.weekStart andEndDate:self.weekEnd];
        
        [self.dataView bringSubviewToFront:self.ptView];
        self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",self.weekStart,self.weekEnd];
        self.startLabel.hidden = YES;
        self.endLabel.hidden = YES;
        
    }
    
}

#pragma mark - 获取一个月前月份
-(NSString *)getLastMonthDateWithDate:(NSString *)currentMonth
{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * mydate = [dateFormatter dateFromString:currentMonth];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:-1];
    
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"yyyy-MM"];
    
    NSString *beforDate = [monthFormatter stringFromDate:newdate];
    NSLog(@"一个月前=%@",beforDate);
    
    
    return beforDate;
}

#pragma mark - 获取下一个月的月份
-(NSString *)getNextMonthDateWithDate:(NSString *)currentMonth
{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * mydate = [dateFormatter dateFromString:currentMonth];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:1];
    
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"yyyy-MM"];
    
    NSString *nextDate = [monthFormatter stringFromDate:newdate];
    NSLog(@"一个月后=%@",nextDate);
    
    
    return nextDate;
}

#pragma mark - 获取某月的月初和月末
-(NSArray *)getMonthBeginAndEndWith:(NSString *)dateStr{
    
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        
        return @[@"",@""];
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *s = [NSString stringWithFormat:@"%@=%@",beginString,endString];
    
    NSArray *array = [s componentsSeparatedByString:@"="];
    
    return array;
}


#pragma mark - 上一个月
-(void)leftClick
{
    
    if (self.selectedButton.tag == 10) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *lastStart = [self getLastMonthDateWithDate:self.startDate];
        
        NSArray *lastArray = [self getMonthBeginAndEndWith:lastStart];
        
        NSLog(@"上月%@--上月初：%@--上月末：%@",lastStart,lastArray[0],lastArray[1]);
        
        [_dateArray removeAllObjects];
        [_milesArray removeAllObjects];
        _chartView = nil;
        [_chartView removeFromSuperview];
        
        self.startDate = lastArray[0];
        self.endDate = lastArray[1];
        
        [self getDataWithStartDate:self.startDate andEndDate:self.endDate];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",self.startDate,self.endDate];
        
        self.isGoOn = YES;
        
    }else{
        
        
        [_dateArray removeAllObjects];
        [_milesArray removeAllObjects];
        
        self.weekEnd = [self getYesterdayWithDate:self.weekStart];
        self.weekStart = [self getLastWeekDateWithCurrentDate:self.weekEnd];
        
        [self getDataWithStartDate:self.weekStart andEndDate:self.weekEnd];
        
        self.weekGoOn = YES;
    }
    
    
}

#pragma mark - 下一个月
-(void)rightClick
{
    
    
    if (self.selectedButton.tag == 10) {
        
        if (self.isGoOn == NO) {
            [MBProgressHUD showMessag:@"已经是最后一页啦" toView:kWindow andShowTime:1];
            
            return ;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *nextStart = [self getNextMonthDateWithDate:self.startDate];
        NSArray *nextArray = [self getMonthBeginAndEndWith:nextStart];
        
        NSLog(@"下月%@--下月初：%@--下月末：%@",nextStart,nextArray[0],nextArray[1]);
        
        [_dateArray removeAllObjects];
        [_milesArray removeAllObjects];
        _chartView = nil;
        [_chartView removeFromSuperview];
        
        self.startDate = nextArray[0];
        
        if ([self.startDate isEqualToString:self.currentMonthStart]) {
            
            self.endDate = self.currentMonthEnd;
            
            self.isGoOn = NO;
        }else{
            
            self.endDate = nextArray[1];
        }
        
        [self getDataWithStartDate:self.startDate andEndDate:self.endDate];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",self.startDate,self.endDate];
        
    }else{
        
        
        if (self.weekGoOn == NO) {
            
            [MBProgressHUD showMessag:@"已经是最后一页啦" toView:kWindow andShowTime:1];
            
            return ;
        }
        
        [_dateArray removeAllObjects];
        [_milesArray removeAllObjects];
        
        
        self.weekStart = [self getTomorrowWithDate:self.weekEnd];
        
        if ([self.weekStart isEqualToString:self.currentWeekStart]) {
            
            self.weekEnd = self.currentWeekEnd;
            
            self.weekGoOn = NO;
        }else{
            
            self.weekEnd = [self getNextWeekDateWithCurrentDate:self.weekStart];
            
        }
        
        [self getDataWithStartDate:self.weekStart andEndDate:self.weekEnd];
        
    }
    
    
}

#pragma mark - 获取某个月的天数
- (NSInteger)getSumOfDaysInMonth:(NSString *)year month:(NSString *)month
{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM"]; // 年-月
    
    NSString * dateStr = [NSString stringWithFormat:@"%@-%@",year,month];
    
    NSDate * date = [formatter dateFromString:dateStr];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
    
}

#pragma mark - 根据某天获取前一周的日期
-(NSString *)getLastWeekDateWithCurrentDate:(NSString *)currentDate
{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:currentDate];
    //一周的秒数
    NSTimeInterval time = 6 * 24 * 60 * 60;
    //下周就把"-"去掉
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    
    return startDate;
}

#pragma mark - 根据某天获取前一天的日期
-(NSString *)getYesterdayWithDate:(NSString *)currentDate
{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:currentDate];
    //一周的秒数
    NSTimeInterval time = 1 * 24 * 60 * 60;
    //下周就把"-"去掉
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    
    return startDate;
    
}

#pragma mark - 根据某天获取下一周的日期
-(NSString *)getNextWeekDateWithCurrentDate:(NSString *)currentDate
{
    
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:currentDate];
    //一周的秒数
    NSTimeInterval time = 6 * 24 * 60 * 60;
    //下周就把"-"去掉
    NSDate *lastWeek = [date dateByAddingTimeInterval:time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    
    return startDate;
}

#pragma mark - 根据某天获取明天的日期
-(NSString *)getTomorrowWithDate:(NSString *)currentDate
{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:currentDate];
    //一周的秒数
    NSTimeInterval time = 1 * 24 * 60 * 60;
    //下周就把"-"去掉
    NSDate *lastWeek = [date dateByAddingTimeInterval:time];
    NSString *startDate =  [dateFormatter stringFromDate:lastWeek];
    
    return startDate;
    
}

#pragma mark - 懒加载
-(NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
}

-(NSMutableArray *)milesArray
{
    if (!_milesArray) {
        _milesArray = [[NSMutableArray alloc]init];
    }
    return _milesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
