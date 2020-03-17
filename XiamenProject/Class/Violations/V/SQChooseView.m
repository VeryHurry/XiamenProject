//
//  SQChooseView.m
//  XiamenProject
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQChooseView.h"
#import "SQChooseCell.h"
#import "CompanyListModel.h"
#import "LawListModel.h"

@interface SQChooseView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) XXVoidBlock closeBlock ;
@property (nonatomic, copy) XXNSArrayBlock block ;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign) NSInteger type;


@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SQChooseView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type title:(NSString *)title data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = kWhite;
        if(block)
        {
            self.block = [block copy];
            self.closeBlock = [closeBlock copy];
        }
        self.type = type;
        self.titleStr = title;
        self.data = data;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:kFrame(0, 0, self.xx_width, 45)];
    titleLbl.text = _titleStr;
    titleLbl.font = Font(16);
    titleLbl.textAlignment = 1;
    [self addSubview:titleLbl];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = kFrame(self.xx_width-20-22, 11, 22, 22);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        self.closeBlock();
    }];
    [self addSubview:closeBtn];
    
    UILabel *line = [[UILabel alloc]xx_initLineFrame:kFrame(0, 44, self.xx_width, 1) color:kLightGray];
    [self addSubview:line];
    
    [self addSubview:self.tableView];
    
    UIView *view = [[UIView alloc]xx_initLineFrame:kFrame(0, self.xx_height-70, self.xx_width, 70) color:kWhite];
    [self addSubview:view];
    
    UILabel *line1 = [[UILabel alloc]xx_initLineFrame:kFrame(0, 0, self.xx_width, 1) color:kLightGray];
    [view addSubview:line1];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = kFrame(30, 15, self.xx_width-60, 40);
    submitBtn.backgroundColor = kBlue;
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = Font(16);
    submitBtn.xx_cornerRadius = 20;
    [submitBtn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        self.block(self.selectArr);
    }];
    [view addSubview:submitBtn];
    
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_type == 0 || _type == 2) {
        [self.selectArr removeAllObjects];
        [self.selectArr addObject:kStrNum(indexPath.row)];
        [self.tableView reloadData];
    }
    else
    {
        if ([self.selectArr containsObject:kStrNum(indexPath.row)]) {
            [self.selectArr removeObject:kStrNum(indexPath.row)];
        }
        else
        {
            [self.selectArr addObject:kStrNum(indexPath.row)];
        }
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SQChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choose_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (_type == 0) {
        CompanyModel *model = self.data[indexPath.row];
        [cell setCompanyData:model];
    }
    else if (_type == 1)
    {
        LawListModel *model = self.data[indexPath.row];
        [cell setLawData:model];
    }
    else
    {
        [cell setData:self.data[indexPath.row]];
    }
    if ([self.selectArr containsObject:kStrNum(indexPath.row)]) {
        cell.img.image = [UIImage imageNamed:@"option_1"];
    }
    else
    {
        cell.img.image = [UIImage imageNamed:@"option_2"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - 懒加载
- (UITableView*)tableView
{
    if (_tableView == nil)
    {
        if (_type == 2) {
           _tableView = [[UITableView alloc] initWithFrame:kFrame(0, 45, self.xx_width, 44*self.data.count) style:UITableViewStylePlain];
        }
        else
        {
        _tableView = [[UITableView alloc] initWithFrame:kFrame(0, 45, self.xx_width, 44*9.5) style:UITableViewStylePlain];
        }
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"SQChooseCell" bundle:nil] forCellReuseIdentifier:@"choose_cell"];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}


@end

