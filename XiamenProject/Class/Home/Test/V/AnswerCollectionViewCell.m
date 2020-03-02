//
//  AnswerCollectionViewCell.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/14.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "AnswerCollectionViewCell.h"
#import "AnswerOptionTableViewCell.h"
#import "AnswerHeaderView.h"
#import "AnswerOptionsModel.h"
#import "AnswerSubmitModel.h"


@interface AnswerCollectionViewCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) AnswerHeaderView *headerView;

@property (nonatomic, copy) XXObjBlock block ;

@end

@implementation AnswerCollectionViewCell

- (AnswerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[AnswerHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        //        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (void)setModel:(AnswerDetailModel *)model {
    _model = model;
    self.headerView.model = model;
    [self.tableView reloadData];
}

#pragma mark - tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  self.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"AnswerOptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"AnswerOptionTableViewCell"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10);
        _tableView.tableHeaderView = header;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark  UITableViewDataSource - UITableViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [self endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView.headerHeight;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/* 行数 **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.optionsList.count;
}

/* 选中 **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_model.type == 1) {
        for (int i = 0; i <_model.optionsList.count; i ++) {
            optionsList *model = _model.optionsList[i];
            if (i == indexPath.row) {
                model.checked = YES;
            }
            else
            {
                model.checked = NO;
            }
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    else
    {
        optionsList *model = _model.optionsList[indexPath.row];
        model.checked = !model.checked;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationNone];
    }
    
    optionsList *model = _model.optionsList[indexPath.row];
    AnswerSubmitModel *submitModel = [AnswerSubmitModel new];
    submitModel.titleNo = _model.titleNo;
    if (_model.type == 1) {
        submitModel.answerNo = model.answerNo;
    }
    else
    {
        NSString *answer = @"";
        for (int i = 0; i < _model.optionsList.count; i ++) {
            optionsList *model = _model.optionsList[i];
            if (model.checked) {
                if (answer.length <= 0) {
                    answer = model.answerNo;
                }
                else
                {
                    answer = [NSString stringWithFormat:@"%@%@",answer,model.answerNo];
                }
            }
            
        }
        submitModel.answerNo = answer;
    }
    submitModel.scoreNo = _model.score;
    
    self.block(submitModel);
}

/* cell设置 **/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AnswerOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerOptionTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel: _model.optionsList[indexPath.row]];
    return cell;
    
}

- (void)selectAnswerBlock:(XXObjBlock)block
{
    if(block)
    {
        self.block = [block copy];
    }
}


@end


