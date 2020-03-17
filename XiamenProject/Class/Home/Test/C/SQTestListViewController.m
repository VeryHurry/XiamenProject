//
//  SQTestListViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/13.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQTestListViewController.h"
#import "SQTestHeadViewController.h"
#import "MacroDefinition.h"
#import "SQTestModel.h"
#import "SQTestListCell.h"

@interface SQTestListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *testArr;

@end

@implementation SQTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"培训学习";
    self.isBack = YES;
    
//    UIButton    * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 60, 44)];
//    [customBtn setTitle:@"我的学习" forState:UIControlStateNormal];
//    customBtn.titleLabel.font = Font(13);
//    [customBtn setTitleColor:ColorWithHex(0x959595) forState:UIControlStateNormal];
//    customBtn.enabled = NO;
//    [customBtn addTarget:self action:@selector(myLearn) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
//    self.navigationItem.rightBarButtonItem = barItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SQTestListCell" bundle:nil] forCellReuseIdentifier:@"testList_cell"];
    [self.view addSubview:self.tableView];
    
    [self getMessage];
    
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)myLearn
{
    
}

#pragma mark - Network
- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_ExaminationList) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"]} success:^(id success) {
            if (!kIsEmptyObj(success)) {
                self.testArr = [SQTestModel mj_objectArrayWithKeyValuesArray:success[@"result"]];
                [self.tableView reloadData];
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SQTestListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testList_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SQTestModel *model = self.testArr[indexPath.row];
    [cell setData:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQTestHeadViewController *vc = [[SQTestHeadViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    SQTestModel *model = _testArr[indexPath.row];
    vc.examinationNo = model.examinationNo;
    [self.navigationController pushViewController:vc animated:YES];
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

-(NSArray *)testArr
{
    if (!_testArr) {
        _testArr = [NSArray new];
    }
    return _testArr;
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
