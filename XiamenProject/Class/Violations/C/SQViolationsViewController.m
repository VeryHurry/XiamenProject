//
//  SQViolationsViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/21.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQViolationsViewController.h"
#import "SQViolationsDetailViewController.h"
#import "CQMenuTabView.h"
#import "SQViolationsCell.h"
#import "MacroDefinition.h"
#import "ViolationsListModel.h"

@interface SQViolationsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *lawType;//违法类型

@property (nonatomic, strong) ViolationsListModel *model;

@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation SQViolationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.status = @"0";
    self.lawType = @"";
    self.pageNo = 1;
    [self createTitleView];
    [self menTable];
    self.tableView.frame = kFrame(0, kNav_H +35, kScreen_W, kScreen_H-25-10-kNav_H);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 145;
    [self.tableView registerNib:[UINib nibWithNibName:@"SQViolationsCell" bundle:nil] forCellReuseIdentifier:@"violations_cell"];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo ++;
        [self getMessage];
    }];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//    }];
    [self.view addSubview:self.tableView];
    [self getMessage];
}

- (void)createTitleView
{
    NSArray *array = [NSArray arrayWithObjects:@"未处理",@"已处理", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.frame = CGRectMake(0, 0, 140, 25);
    segment.tintColor = kBlue;
    segment.backgroundColor = [UIColor whiteColor];
    segment.layer.masksToBounds = YES;
    segment.layer.cornerRadius = 3;
    segment.layer.borderWidth = 1;
    segment.layer.borderColor = kBlue.CGColor;
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
}

-(void)change:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex == 0)
    {
        self.status = @"0";
        [self getMessage];
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        self.status = @"2";
        [self getMessage];
    }
}

- (void)menTable
{
    CQMenuTabView *menTable = [[CQMenuTabView alloc] initWithFrame:CGRectMake(0, kNav_H, UIScreen.mainScreen.bounds.size.width, 30)];
    menTable.titleFont = [UIFont systemFontOfSize:12];
    menTable.normaTitleColor = kGray;
    
    menTable.didSelctTitleColor = kBlue;
    menTable.showCursor = YES;
    menTable.cursorStyle = CQTabCursorUnderneath;
    menTable.layoutStyle = CQTabFillParent;
    menTable.cursorHeight = 2;
    menTable.cursorView.backgroundColor =kBlue;
    menTable.backgroundColor = [UIColor whiteColor];
    
    menTable.didTapItemAtIndexBlock = ^(UIView *view, NSInteger index) {
        NSLog(@"...%ld",(long)index);
        if (index == 0) {
            self.lawType = @"";
        }
        else
        {
            self.lawType = kStrNum(index);
        }
        [self getMessage];
    };
    [self.view addSubview:menTable];
    
    menTable.titles = @[@"全部",@"超速",@"闯红灯",@"违规禁行",@"其他"];
}

#pragma mark - 懒加载
- (UITableView*)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:kFrame(0, kNav_H+30+10, kScreen_W, kScreen_H-kNav_H) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SQViolationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"violations_cell" forIndexPath:indexPath];
    [cell setData:_dataArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 145;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SQViolationsDetailViewController *vc = [SQViolationsDetailViewController new];
    vc.model = _dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Network
- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        
        NSDictionary *dic = @{@"mobile":kIsEmptyStr(self.mobile)?[kUserDefaults objectForKey:@"mobile"]:self.mobile,@"status":_status,@"lawType":_lawType,@"pageNum":kStrNum(self.pageNo),@"pageSize":@"20"};
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_LawList) parameters:dic success:^(id success) {
            WeakSelf(ws);
            if (!kIsEmptyObj(success)) {
                ws.dataArr = [ViolationsListModel mj_objectArrayWithKeyValuesArray:success[@"result"]];
                [self.tableView reloadData];
                if (ws.dataArr.count >20*self.pageNo) {
                    [ws.tableView.mj_footer endRefreshing];
                }
                else
                {
                    [ws.tableView.mj_footer endRefreshingWithNoMoreData];
                }
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
