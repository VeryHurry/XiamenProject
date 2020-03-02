//
//  GPS_ChoiceViewController.m
//  LeTu
//
//  Created by mtt on 2018/1/8.
//  Copyright © 2018年 mtt. All rights reserved.
//

#import "GPS_ChoiceViewController.h"
#import "MacroDefinition.h"
#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
@interface GPS_ChoiceViewController ()<UIPickerViewDelegate>

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *timeChoiceView;
@property (nonatomic,strong)UIView *pickerView;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,assign)NSInteger btnIndex;
@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,strong)UIButton *selectedButton;
@property (nonatomic,strong)UILabel *vehicleLabel;
@property (nonatomic,assign)NSInteger typeIndex;

@end

@implementation GPS_ChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    self.view.userInteractionEnabled = YES;
    self.typeIndex = 0;
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, kScreen_H - 200*Scale - 15, kScreen_W-20, 200*Scale)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 4.0f;
    [self.view addSubview:self.bgView];
    
//    播放轨迹
    UIButton *playButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 140*Scale, kScreen_W-50, 45*Scale)];
    playButton.backgroundColor = [UIColor colorWithHexStr:@"#FF8043"];
    playButton.titleLabel.font = [UIFont systemFontOfSize:17*Scale weight:UIFontWeightBold];
    playButton.layer.masksToBounds = YES;
    playButton.layer.cornerRadius = 4;
    [playButton setTitle:@"播放轨迹" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor colorWithHexStr:@"#ffffff"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:playButton];
    
//    车牌号
    self.vehicleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 120*Scale, 20*Scale)];
    self.vehicleLabel.text = self.vehicleNo;
    self.vehicleLabel.textColor = [UIColor colorWithHexStr:@"#222222"];
    self.vehicleLabel.font = [UIFont systemFontOfSize:15*Scale weight:UIFontWeightRegular];
    [self.bgView addSubview:self.vehicleLabel];
    
    NSArray *timeArray = @[@"1小时前",@"今天",@"昨天"];
    for (int i = 0; i < 3; i++) {
        
        UIButton *timeButton = [[UIButton alloc]initWithFrame:CGRectMake(160*Scale + i*65*Scale, 15, 50*Scale, 20*Scale)];
        timeButton.tag = 20 + i;
        timeButton.titleLabel.font = [UIFont systemFontOfSize:10*Scale weight:UIFontWeightRegular];
        timeButton.backgroundColor = [UIColor colorWithHexStr:@"#D3D4D6"];
        timeButton.layer.masksToBounds = YES;
        timeButton.layer.cornerRadius = 10*Scale;
        [timeButton setTitle:timeArray[i] forState:UIControlStateNormal];
        [timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        if (i == 0) {
//            timeButton.backgroundColor = [UIColor colorWithHexStr:@"#4C50FC"];
//            self.selectedButton = timeButton;
//        }
        [timeButton addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:timeButton];
        
    }
    
    NSArray *startArray = @[@"  开始时间",@"  结束时间"];
    NSDate *dateToday = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:dateToday];
    for (int i = 0; i < 2; i++) {
        
        UIButton *timeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 55*Scale + i*30*Scale, 90*Scale, 30*Scale)];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14*Scale weight:UIFontWeightRegular];
        [timeBtn setTitle:startArray[i] forState:UIControlStateNormal];
        [timeBtn setTitleColor:[UIColor colorWithHexStr:@"#3b3b3b"] forState:UIControlStateNormal];
        [timeBtn setImage:[UIImage imageNamed:@"icon_time"] forState:UIControlStateNormal];
        [self.bgView addSubview:timeBtn];
        
        
        UIButton *dateButton = [[UIButton alloc]init];
        dateButton.tag = 10 + i;
        dateButton.titleLabel.font = [UIFont systemFontOfSize:14*Scale weight:UIFontWeightRegular];
        [dateButton setTitle:dateString forState:UIControlStateNormal];
        [dateButton setTitleColor:[UIColor colorWithHexStr:@"#999999"] forState:UIControlStateNormal];
        [dateButton addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:dateButton];
        [dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeBtn.mas_right).offset(0);
            make.centerY.equalTo(timeBtn.mas_centerY).offset(0);
            make.width.offset(200*Scale);
            make.height.offset(30*Scale);
        }];
        
    }
    
    
//    创建时间选择View
//    [self createTimePicker];
    
    
}

#pragma mark - 选择时间
-(void)timeClick:(UIButton *)btn
{
    
    NSLog(@"%ld",btn.tag);
    
    self.typeIndex = btn.tag - 19;
    
    self.selectedButton.backgroundColor = [UIColor colorWithHexStr:@"#D3D4D6"];
    btn.backgroundColor = [UIColor colorWithHexStr:@"#4C50FC"];
    self.selectedButton = btn;
    
    
    
}

#pragma mark - 选择自定义按钮
-(void)choiceClick:(UIButton *)btn
{
    if (self.typeIndex == 0 ) {
        [MBProgressHUD showMessag:@"请选择查询时间" toView:self.view andShowTime:1];
    }
    else
    {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if (self.pathBlock) {
            self.pathBlock(self.typeIndex,self.startTime,self.endTime);
        }
    }
}

#pragma mark - 自定义时间
-(void)createTimePicker
{
    
    self.timeChoiceView = [[UIView alloc]init];
    self.timeChoiceView.hidden = YES;
    self.timeChoiceView.center = CGPointMake(kScreen_W/2, kScreen_H/2);
    self.timeChoiceView.bounds = CGRectMake(0, 0, kScreen_W-100*Scale, 185*Scale);
    self.timeChoiceView.backgroundColor = [UIColor whiteColor];
    self.timeChoiceView.layer.masksToBounds = YES;
    self.timeChoiceView.clipsToBounds = YES;
    self.timeChoiceView.layer.cornerRadius = 10.0f;
    [self.view addSubview:self.timeChoiceView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_W-100*Scale, 45*Scale)];
    titleLabel.text = @"自定义";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor blackColor];
    [self.timeChoiceView addSubview:titleLabel];
    
    NSArray *timeArray = @[@"开始时间",@"结束时间"];
    for (int i = 0; i < 3; i++) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*45*Scale, kScreen_W-100*Scale, 1.0)];
        line.backgroundColor = [UIColor colorWithHexStr:@"#e6e6e6"];
        [self.timeChoiceView addSubview:line];
        
        if (i<2) {
            
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (i+1)*45*Scale, 80*Scale, 45*Scale)];
            timeLabel.text = timeArray[i];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.font = [UIFont systemFontOfSize:15*Scale];
            timeLabel.textColor = [UIColor colorWithHexStr:@"#686868"];
            [self.timeChoiceView addSubview:timeLabel];
            
            
            UIButton *choiceButton = [[UIButton alloc]init];
            choiceButton.tag = 20 + i;
            choiceButton.titleLabel.font = [UIFont systemFontOfSize:15*Scale];
            [choiceButton setTitle:@"请选择时间" forState:UIControlStateNormal];
            [choiceButton setTitleColor:[UIColor colorWithHexStr:@"#1383ff"] forState:UIControlStateNormal];
            [choiceButton addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.timeChoiceView addSubview:choiceButton];
            [choiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(timeLabel.mas_right).offset(0);
                make.right.equalTo(self.timeChoiceView.mas_right).offset(0);
                make.centerY.equalTo(timeLabel.mas_centerY).offset(0);
                make.height.offset(45*Scale);
            }];
            
            
        }
        
    }
    
    
    UIView *verticalLine = [[UIView alloc]init];
    verticalLine.backgroundColor = [UIColor colorWithHexStr:@"#e6e6e6"];
    [self.timeChoiceView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(0);
        make.height.offset(50*Scale);
        make.width.offset(1.0);
    }];
    
    
    NSArray *buttonArray = @[@"取消",@"确定"];
    for (int i = 0; i<2; i++) {
        
        UIButton *choiceBtn = [[UIButton alloc]init];
        choiceBtn.tag = 20 + i;
        choiceBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [choiceBtn setTitle:buttonArray[i] forState:UIControlStateNormal];
        [choiceBtn setTitleColor:[UIColor colorWithHexStr:@"#686868"] forState:UIControlStateNormal];
        [choiceBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeChoiceView addSubview:choiceBtn];
        [choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeChoiceView.mas_left).offset(i*(kScreen_W-100*Scale)/2);
            make.bottom.offset(0);
            make.height.offset(50*Scale);
            make.width.offset((kScreen_W-100*Scale)/2);
        }];
        
    }
    
    
    
}

#pragma mark - 选择开始/结束时间
-(void)startClick:(UIButton *)btn
{
    self.typeIndex = 5;
    
    [self.pickerView removeFromSuperview];
    
    self.pickerView = [[UIView alloc]init];
    self.pickerView.center = CGPointMake(kScreen_W/2, kScreen_H/2 - 50*Scale);
    self.pickerView.bounds = CGRectMake(0, 0, kScreen_W-50*Scale, 260*Scale);
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.clipsToBounds = YES;
    self.pickerView.layer.cornerRadius = 10.0f;
    [self.view addSubview:self.pickerView];
    
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, kScreen_W-50*Scale, 210*Scale)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//    self.datePicker.minimumDate = minDate;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.pickerView addSubview:self.datePicker];
    
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 210*Scale, (kScreen_W-50*Scale)/2, 50*Scale)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView addSubview:cancelButton];
    
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreen_W-50*Scale)/2, 210*Scale, (kScreen_W-50*Scale)/2, 50*Scale)];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(ensureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView addSubview:confirmButton];
    
    self.btnIndex = btn.tag;
    
    if (self.btnIndex == 10) {
        self.startTime = @"";
    }else{
        self.endTime = @"";
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [formatter stringFromDate:date];
    if (self.startTime.length == 0 && self.btnIndex == 10) {
        self.startTime = string;
//        NSLog(@"调用1>>>%@",self.startTime);
    }
    if (self.endTime.length == 0 && self.btnIndex == 11) {
        self.endTime = string;
//        NSLog(@"调用2>>>%@",self.endTime);
    }
    
}

#pragma mark - 取消/确定
-(void)confirmClick:(UIButton *)btn
{
    
    if (self.typeIndex == 0) {
        
        [MBProgressHUD showMessag:@"请选择查询时间" toView:kWindow andShowTime:1];
        
    }else{
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if (self.pathBlock) {
            self.pathBlock(self.typeIndex,self.startTime,self.endTime);
        }
        
    }
    
    
}

#pragma mark - 时间改变
-(void)dateChanged:(UIDatePicker *)sender
{
    
//    获取当前选择器选中的的日期和时间
    NSDate *date = sender.date;
    
//    设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
//    将定好的时间格式以字符串的形式输出
    NSString *string = [formatter stringFromDate:date];
    
    if (self.btnIndex == 10) {
        
        self.startTime = string;
        NSLog(@"开始时间>>>%@",self.startTime);
        
    }else{
        
        self.endTime = string;
        NSLog(@"结束时间>>>%@",self.endTime);
    }
    
    
}

-(void)cancelClick
{
    [self.pickerView removeFromSuperview];
}

-(void)ensureClick
{
    if (self.btnIndex == 10) {
        
//        开始时间
        NSLog(@"%ld---%@",self.btnIndex,self.startTime);
        UIButton *startBtn = (UIButton *)[self.view viewWithTag:10];
        [startBtn setTitle:self.startTime forState:UIControlStateNormal];
        
    }else{
        
//        结束时间
        NSLog(@"%ld---%@",self.btnIndex,self.endTime);
        UIButton *endBtn = (UIButton *)[self.view viewWithTag:11];
        [endBtn setTitle:self.endTime forState:UIControlStateNormal];
        
    }
    
    
    [self.pickerView removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
