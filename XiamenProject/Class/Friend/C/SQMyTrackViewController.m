
//
//  SQFriendViewController.m
//  LeTu
//
//  Created by MacStudent on 2019/5/8.
//  Copyright © 2019 mtt. All rights reserved.
//

#import "SQMyTrackViewController.h"
#import "SQTrackDetailViewController.h"
#import "MacroDefinition.h"
#import "MyTrackModel.h"
#import "SQMyTrackCell.h"
@interface SQMyTrackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) MyTrackModel *model;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SQMyTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程";
    self.isBack = NO;
    self.pageNo = 1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SQMyTrackCell" bundle:nil] forCellReuseIdentifier:@"track_cell"];
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

- (void)viewWillAppear:(BOOL)animated
{
    [self getMessage];
}

#pragma mark - 懒加载
- (UITableView*)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:kFrame(0, kNav_H+8, kScreen_W, kScreen_H-kNav_H-8-TabBar_Height) style:UITableViewStylePlain];
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
    
    SQMyTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"track_cell" forIndexPath:indexPath];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SQTrackDetailViewController *vc = [SQTrackDetailViewController new];
    vc.model = _dataArr[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - network
- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_MyTrack) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"],@"pageNum":kStrNum(self.pageNo),@"pageSize":@"20"} success:^(id success) {
            WeakSelf(ws);
            if (!kIsEmptyObj(success)) {
                ws.dataArr = [trackModel mj_objectArrayWithKeyValuesArray:success[@"result"]];
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
