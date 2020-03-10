//
//  SQAnswerViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/14.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQAnswerViewController.h"
#import "AnswerCollectionViewCell.h"
#import "SQTestResultViewController.h"
#import "SQFiveResultViewController.h"
#import "AnswerFooterView.h"
#import "AnswerSheetView.h"
#import "MacroDefinition.h"
#import "TestListModel.h"
#import "AnswerSubmitModel.h"
#import "AnswerDetailModel.h"
#import "FiveSubjectModel.h"

@interface SQAnswerViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) AnswerFooterView *footerView;

@property (nonatomic,strong) AnswerSheetView *sheetView;

@property (nonatomic,strong) TestListModel *model;

@property (nonatomic,strong) FiveSubjectModel *fiveModel;

@property (nonatomic, strong) NSArray *sortAnswerArr, *sortArr;

@property (nonatomic, strong) NSMutableArray *submitArr;

/**
 当前位置，只能滑动至下一题时使用
 */
@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property (nonatomic, assign) BOOL isOpen;


@end

@implementation SQAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全考试";
    self.isBack = YES;
    self.view.backgroundColor = kWhite;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [kWindow addSubview:self.footerView];
    
    if (_type == 1) {
        [self getFiveSubject];
    }
    else
    {
        UIButton  * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 50, 44)];
        [customBtn setTitle:@"进度" forState:UIControlStateNormal];
        customBtn.titleLabel.font = Font(13);
        customBtn.titleLabel.textAlignment = 2;
        [customBtn setTitleColor:ColorWithHex(0x959595) forState:UIControlStateNormal];
        customBtn.enabled = NO;
        customBtn.tag = 1;
        [customBtn addTarget:self action:@selector(progress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
        self.navigationItem.rightBarButtonItem = barItem;
        [kWindow addSubview:self.sheetView];
        [self getMessage];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.footerView removeFromSuperview];
    [self closeSheetView:YES];
}

- (void)back
{
    if (_type == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)progress:(UIButton *)sender
{
    
    if (!_isOpen) {
        [self.sheetView reload:[self judgeAnswer]];
        [self closeSheetView:NO];
    }
    else
    {
        [self closeSheetView:YES];
    }
    _isOpen = !_isOpen;
}

- (void)closeSheetView:(BOOL)isOpen
{
    if (!isOpen) {
        [self.sheetView reload:[self judgeAnswer]];
        [UIView animateWithDuration:0.2 animations:^{
            self.sheetView.frame = kFrame(0, kNav_H, kScreen_W, self.sheetView.frame.size.height);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.sheetView.frame = kFrame(0, -self.sheetView.frame.size.height, kScreen_W, self.sheetView.frame.size.height);
        }];
    }
}

#pragma mark - collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNav_H+6, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -kNav_H-6) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        
        //        _collectionView.scrollEnabled = !GetAnswernextque; // 如果只能滑动至下一题取消滚动效果
        [_collectionView registerClass:[AnswerCollectionViewCell class] forCellWithReuseIdentifier:@"AnswerCollectionViewCell"];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"scrollView.cotentOffset.x:%f",scrollView.contentOffset.x);
    //
    //    NSLog(@"scrollViewDidScroll-visibleCells:%@",self.collectionView.visibleCells);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    NSLog(@"scrollViewDidEndDecelerating");
    //
    //    NSLog(@"scrollViewDidEndDecelerating-visibleCells:%@",self.collectionView.visibleCells);
    
    if (self.collectionView.visibleCells.count == 1) {
        if ([self.collectionView.visibleCells.firstObject isKindOfClass:[AnswerCollectionViewCell class]]) {
            self.currentIndexPath = [self.collectionView indexPathForCell:self.collectionView.visibleCells.firstObject];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //    NSLog(@"scrollViewDidEndScrollingAnimation");
    //
    //    NSLog(@"scrollViewDidEndScrollingAnimation-visibleCells:%@",self.collectionView.visibleCells);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

/* 个数 **/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _sortAnswerArr.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

/* cell设置 **/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnswerCollectionViewCell" forIndexPath:indexPath];
    
    cell.model= _sortAnswerArr[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    //    __weak __typeof(self) wself = self;
    [cell selectAnswerBlock:^(id obj) {
        AnswerSubmitModel *model = obj;
        [self addModel:model];
        [self isFinish];
    }];
    
    return cell;
}

#pragma mark - Network
- (void)getFiveSubject
{
    [Base_AFN_Manager postUrl:IP_SPLICE(IP_GetFiveSubject) parameters:@{@"accountNo":[kUserDefaults objectForKey:@"mobile"]} success:^(id success) {
        __weak __typeof(self) wself = self;
        if (!kIsEmptyObj(success)) {
            NSLog(@"-------*****%@",success);
            
            wself.fiveModel = [FiveSubjectModel mj_objectWithKeyValues:success];
            
            wself.sortAnswerArr = [self sortSubjectListArray:wself.fiveModel.result];
            wself.sortArr = [self getSortArr];
            [self.collectionView reloadData];
            
        }
        
        
    } failure_login:nil failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
}

- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_GetExamination) parameters:@{@"examinationNo":_examinationNo} success:^(id success) {
            __weak __typeof(self) wself = self;
            if (!kIsEmptyObj(success)) {
                wself.model = [TestListModel mj_objectWithKeyValues:success];
                wself.sortAnswerArr = [self sortSubjectListArray:wself.model.subjectList];
                wself.sortArr = [wself.model.result.titleNo componentsSeparatedByString:@","];
                [self.collectionView reloadData];
                [self.sheetView reload:[self judgeAnswer]];
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:false];
                //                });
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (void)submitFiveByData:(NSDictionary *)dic
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_AddClockin) parameters:dic success:^(id success) {
            //            __weak __typeof(self) wself = self;
            if (!kIsEmptyObj(success)) {
                
                SQFiveResultViewController *vc = [SQFiveResultViewController new];
                vc.result = success[@"msg"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (void)submitByData:(NSDictionary *)dic
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_SubmitTest) parameters:dic success:^(id success) {
            //            __weak __typeof(self) wself = self;
            if (!kIsEmptyObj(success)) {
                SQTestResultViewController *vc = [SQTestResultViewController new];
                vc.resultDic = success;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

#pragma mark - data
- (void)addModel:(AnswerSubmitModel *)aModel
{
    __block BOOL isExist = NO;
    [self.submitArr enumerateObjectsUsingBlock:^(AnswerSubmitModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.titleNo == aModel.titleNo) {
            [self.submitArr replaceObjectAtIndex:idx withObject:aModel];
            *stop = YES;
            isExist = YES;
        }
    }];
    if (!isExist) {//如果不存在就添加进去
        [self.submitArr addObject:aModel];
    }
//    NSLog(@"---------%@",self.submitArr);
}


- (NSDictionary *)submitFiveData:(NSArray *)arr
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *answerNo = @"";
    for (int i = 0; i < arr.count; i ++) {
        AnswerSubmitModel *model = arr[i];
        if (i == 0) {
            answerNo = model.answerNo;
        }
        else
        {
            answerNo = [NSString stringWithFormat:@"%@,%@",answerNo,model.answerNo];
        }
    }
    [dic setObject:[kUserDefaults objectForKey:@"mobile"] forKey:@"accountNo"];
    [dic setObject:answerNo forKey:@"answer"];
    return dic;
}

- (NSDictionary *)submitData:(NSArray *)arr
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *titleNo = @"";
    NSString *answerNo = @"";
    NSString *scoreNo = @"";
    for (int i = 0; i < arr.count; i ++) {
        AnswerSubmitModel *model = arr[i];
        if (i == 0) {
            titleNo = kStrNum(model.titleNo);
            answerNo = model.answerNo;
            scoreNo = kStrNum(model.scoreNo);
        }
        else
        {
            
            titleNo = [NSString stringWithFormat:@"%@,%ld",titleNo,(long)model.titleNo];
            answerNo = [NSString stringWithFormat:@"%@,%@",answerNo,model.answerNo];
            scoreNo = [NSString stringWithFormat:@"%@,%ld",scoreNo,(long)model.scoreNo];
        }
    }
    [dic setObject:titleNo forKey:@"titleNo"];
    [dic setObject:answerNo forKey:@"answerNo"];
    [dic setObject:scoreNo forKey:@"scoreNo"];
    [dic setObject:_model.result.examinationNo forKey:@"examinationNo"];
    [dic setObject:[kUserDefaults objectForKey:@"mobile"] forKey:@"mobile"];
    
    return dic;
}

- (NSArray *)getOptionsList:(NSString *)string {
    
    NSArray *arr = [string componentsSeparatedByString:@"|"];
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSString *str in arr) {
        NSArray *temp = [str componentsSeparatedByString:@":"];
        optionsList *model = [optionsList new];
        model.checked = NO;
        model.answerNo = temp[0];
        model.answer = temp[1];
        [tempArr addObject:model];
    }
    return tempArr;
}


- (NSArray *)sortSubjectListArray:(NSArray *)arr
{
    NSMutableArray *temp = [NSMutableArray new];
    if (_type == 1) {
        for (SubjectModel *aModel in arr) {
            AnswerDetailModel *model = [AnswerDetailModel new];
            model.titleNo = aModel.ID;
            model.score = aModel.score;
            model.type = aModel.type;
            model.title = aModel.title;
            model.answer = aModel.answer;
            model.optionsList = [self getOptionsList:aModel.options];
            [temp addObject:model];
        }
    }
    else
    {
        for (Subjectlist *aModel in arr) {
            AnswerDetailModel *model = [AnswerDetailModel new];
            model.titleNo = aModel.ID;
            model.score = aModel.score;
            model.type = aModel.type;
            model.title = aModel.title;
            model.answer = aModel.answer;
            model.optionsList = [self getOptionsList:aModel.options];
            [temp addObject:model];
        }
    }
    //排序
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"titleNo" ascending:YES];
//    NSArray *tempArr = [temp sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return temp;
}

- (NSArray *)sortSubmitArray:(NSArray *)arr
{
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"titleNo" ascending:YES];
//    NSArray *tempArr = [arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSMutableArray *tempArr = [NSMutableArray new];
    
    NSLog(@"sortArr==%@",self.sortArr);
    
    for (int i = 0; i < self.sortArr.count; i ++) {
        for (int j = 0; j < arr.count; j++) {
            AnswerSubmitModel *model = arr[j];
            if ([self.sortArr[i] integerValue] == model.titleNo) {
                [tempArr addObject:model];
            }
        }
    }
    
    
    return tempArr;
}

- (NSArray *)judgeAnswer
{
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < _sortAnswerArr.count; i ++) {
        AnswerDetailModel *model = _sortAnswerArr[i];
        //        for (int j = 0; j < _submitArr.count; j ++) {
        //            AnswerSubmitModel *subModel = _sortAnswerArr[j];
        //            if (model.titleNo == subModel.titleNo) {
        //
        //            }
        //        }
        
        __block BOOL isExist = NO;
        [self.submitArr enumerateObjectsUsingBlock:^(AnswerSubmitModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.titleNo == model.titleNo) {
                [temp addObject:@"1"];
                *stop = YES;
                isExist = YES;
            }
        }];
        if (!isExist) {//如果不存在就添加进去
            [temp addObject:@"0"];
        }
        
        
    }
    return temp;
}


#pragma mark - other
- (void)isFinish
{
    if (_type == 1) {
        if (self.submitArr.count >= _fiveModel.result.count) {
            [UIView animateWithDuration:0.5 animations:^{
                self.footerView.frame = kFrame(0, kScreen_H-45, kScreen_W, 45);
            }];
        }
    }
    else
    {
    if (self.submitArr.count >= _model.subjectList.count) {
        //    if (self.submitArr.count >= _model.subjectList.count) {
        [UIView animateWithDuration:0.5 animations:^{
            self.footerView.frame = kFrame(0, kScreen_H-45, kScreen_W, 45);
        }];
    }
    }
}

- (NSArray *)getSortArr
{
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < _fiveModel.result.count; i ++) {
        SubjectModel *model = _fiveModel.result[i];
        [temp addObject:kStrNum(model.ID)];
    }
    return temp;
}

#pragma mark - get
- (NSMutableArray *)submitArr
{
    if (!_submitArr) {
        _submitArr = [NSMutableArray new];
    }
    return _submitArr;
}

- (AnswerFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[AnswerFooterView alloc]initWithFrame:kFrame(0, kScreen_H, kScreen_W, 45) block:^(NSInteger num) {
            if (self.type == 1) {
                NSDictionary *dic = [self submitFiveData:[self sortSubmitArray:self.submitArr]];
                [self submitFiveByData:dic];
            }
            else
            {
                NSDictionary *dic = [self submitData:[self sortSubmitArray:self.submitArr]] ;
                [self submitByData:dic];
            }
                
            
        }];
    }
    return _footerView;
}

- (AnswerSheetView *)sheetView
{
    if (!_sheetView) {
        CGFloat width = kScale_W(25) ;
        CGFloat spacing_v = kScale_W(25);
        CGFloat height = spacing_v*5 +width*6+50;
        _sheetView = [[AnswerSheetView alloc]initWithFrame:kFrame(0, -height, kScreen_W, height) type:0 block:^(NSInteger num) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeSheetView:YES];
                self.isOpen = !self.isOpen;
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:num inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            });
        }];
    }
    return _sheetView;
}

@end


