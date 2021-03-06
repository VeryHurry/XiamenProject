//
//  SQViolationsFeedbackViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/22.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQViolationsFeedbackViewController.h"
#import "SQMapViewController.h"
#import "SQMyLawListViewController.h"
#import "InputView.h"
#import "MacroDefinition.h"
#import "XG_AssetPickerController.h"
#import "SelectedAssetCell.h"
#import "LawListModel.h"
#import "CompanyListModel.h"
#import "SQChooseView.h"

#define kCollectionViewSectionInsetLeftRight 16
#define kItemCountAtEachRow 3
#define kMinimumInteritemSpacing 8
#define kMinimumLineSpacing 8

@interface SQViolationsFeedbackViewController ()<UITextViewDelegate,XG_AssetPickerControllerDelegate,UIAlertViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<XG_AssetModel *> *assets;
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, strong) XG_AssetModel *placeholderModel;


@property (weak, nonatomic) IBOutlet UIView *bgHead;
@property (weak, nonatomic) IBOutlet UITextField *noLbl;
@property (weak, nonatomic) IBOutlet UIImageView *noImg;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;
@property (weak, nonatomic) IBOutlet UIImageView *companyImg;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (nonatomic, strong) NSArray *dataArr, *selectArr;
@property (nonatomic, strong) NSArray *comanyArr, *selectCompanyArr;
@property (nonatomic, strong) NSArray *typeArr, *selectTypeArr;

@property (nonatomic, strong) SQChooseView *typeView;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, strong) SQChooseView *companyView;
@property (nonatomic, strong) SQChooseView *chooseView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation SQViolationsFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLawList];
    [self getCompanyList];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.typeView];
    
    self.isBack = YES;
    self.typeBtn.titleLabel.numberOfLines = 0;
    if (!kIsEmptyStr(self.address)) {
        [self.addressBtn setTitle:self.address forState:UIControlStateNormal];
        [self.addressBtn setTitleColor:kBlack forState:UIControlStateNormal];
    }
    
    if (!kIsEmptyStr(self.accounted)) {
        self.noLbl.text = self.accounted;
        self.typeName.text = @"骑手编号";
        self.noLbl.placeholder = @"请输入骑手编号";
        self.noImg.hidden = YES;
        self.noButton.hidden = YES;
    }
    if (!kIsEmptyStr(self.parentId)) {
        self.noLbl.text = self.parentName;
        self.companyId = self.parentId;
    }
    
    //    self.title = @"随时拍";
    UIButton  * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 50, 44)];
    [customBtn setTitle:@"我的随手拍" forState:UIControlStateNormal];
    customBtn.titleLabel.font = Font(13);
    customBtn.titleLabel.textAlignment = 2;
    [customBtn setTitleColor:ColorWithHex(0x959595) forState:UIControlStateNormal];
    customBtn.enabled = NO;
    customBtn.tag = 1;
    [customBtn addTarget:self action:@selector(mine) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    
//    _inputView = [[InputView alloc] init];
//    [self.bgHead addSubview:_inputView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWH = (self.view.frame.size.width -14- (kItemCountAtEachRow-1)*kMinimumInteritemSpacing - 2*kCollectionViewSectionInsetLeftRight)/kItemCountAtEachRow;
    layout.itemSize = CGSizeMake(kScale_W(86), kScale_W(86));
    layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
    layout.minimumLineSpacing = kMinimumLineSpacing;
    layout.sectionInset = UIEdgeInsetsMake(15, kCollectionViewSectionInsetLeftRight, 15, kCollectionViewSectionInsetLeftRight);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SelectedAssetCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SelectedAssetCell class])];
    self.collectionView.scrollEnabled = NO;
    
   
}

-(void)mine
{
    SQMyLawListViewController *vc = [SQMyLawListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectType:(id)sender
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0.4;
        self.typeView.frame = kFrame(0, kScreen_H-(45+70+44*2), kScreen_W, 45+70+44*2);
    }];
}
     
- (IBAction)selectCompany:(id)sender
{
    if (!kIsEmptyArr(self.comanyArr)) {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0.4;
        self.companyView.frame = kFrame(0, kScreen_H-(45+70+44*9.5), kScreen_W, 45+70+44*9.5);
    }];
    }
}

- (IBAction)type:(id)sender
{
    if (!kIsEmptyArr(self.dataArr)) {
        [self.view endEditing:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.maskView.alpha = 0.4;
            self.chooseView.frame = kFrame(0, kScreen_H-(45+70+44*9.5), kScreen_W, 45+70+44*9.5);
        }];
    }
    
//    CZHAlertView *alertView = [CZHAlertView czh_alertViewWithPreferredStyle:CZHAlertViewStyleActionSheet];
//
//    CZHAlertItem *item = [CZHAlertItem czh_itemWithTitle:@"闯红灯" style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
//        [self.typeBtn setTitle:item.title forState:UIControlStateNormal];
//        [self.typeBtn setTitleColor:kBlack forState:UIControlStateNormal];
//    }];
//
//    CZHAlertItem *item1 = [CZHAlertItem czh_itemWithTitle:@"超速" style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
//        [self.typeBtn setTitle:item.title forState:UIControlStateNormal];
//        [self.typeBtn setTitleColor:kBlack forState:UIControlStateNormal];
//    }];
//
//    CZHAlertItem *item2 = [CZHAlertItem czh_itemWithTitle:@"违规禁行" style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
//        [self.typeBtn setTitle:item.title forState:UIControlStateNormal];
//        [self.typeBtn setTitleColor:kBlack forState:UIControlStateNormal];
//    }];
//
//    CZHAlertItem *item3 = [CZHAlertItem czh_itemWithTitle:@"其他" style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
//        [self.typeBtn setTitle:item.title forState:UIControlStateNormal];
//        [self.typeBtn setTitleColor:kBlack forState:UIControlStateNormal];
//    }];
//
//    [alertView czh_addAlertItem:item];
//    [alertView czh_addAlertItem:item1];
//    [alertView czh_addAlertItem:item2];
//    [alertView czh_addAlertItem:item3];
//
//    [alertView czh_showView];
}

- (IBAction)address:(id)sender
{
    [self.view endEditing:YES];
    SQMapViewController *vc = [SQMapViewController new];
    [vc selectAddress:^(NSArray *arr) {
        [self.addressBtn setTitle:arr[0] forState:UIControlStateNormal];
        [self.addressBtn setTitleColor:kBlack forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)submit:(id)sender
{
    if (kIsEmptyStr(_noLbl.text)) {
        [MBProgressHUD showError:@"请先输入员工编号"];
        return;
    }
    if (kIsEmptyStr(_typeBtn.titleLabel.text)||[_typeBtn.titleLabel.text isEqualToString:@"请选择违规类型"]) {
        [MBProgressHUD showError:@"请先选择违规类型"];
        return;
    }
    if (kIsEmptyStr(_addressBtn.titleLabel.text)||[_addressBtn.titleLabel.text isEqualToString:@"请选择违规地址"]) {
            [MBProgressHUD showError:@"请先选择违规地址"];
            return;
    }
    if (kIsEmptyStr(_content.text)||[_content.text isEqualToString:@"请输入您要提交的违规行为"]) {
        [MBProgressHUD showError:@"请输入您要提交的违规行为"];
        return;
    }
    if (kIsEmptyArr(_photoArr)) {
        [MBProgressHUD showError:@"请先选择违规图片"];
        return;
    }
    [self networkingForUploadImg:self.photoArr];
}



#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = kBlack;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        textView.text = @"请输入您要提交的违规行为";
        textView.textColor = kLightGray;
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        textView.text = @"请输入您要提交的违规行为";
        textView.textColor = kLightGray;
        [textView resignFirstResponder];
    }
}

-(NSMutableArray<XG_AssetModel *> *)assets{
    if (!_assets) {
        _assets = @[self.placeholderModel].mutableCopy;
    }
    return _assets;
}

-(XG_AssetModel *)placeholderModel{
    if (!_placeholderModel) {
        _placeholderModel = [[XG_AssetModel alloc]init];
        _placeholderModel.isPlaceholder = YES;
    }
    return _placeholderModel;
}


- (void)openAlbum{
    __weak typeof (self) weakSelf = self;
    [[XG_AssetPickerManager manager] handleAuthorizationWithCompletion:^(XG_AuthorizationStatus aStatus) {
        if (aStatus == XG_AuthorizationStatusAuthorized) {
            [weakSelf showAssetPickerController];
        }else{
            [weakSelf showAlert];
        }
    }];
}

- (void)showAssetPickerController{
    XG_AssetPickerOptions *options = [[XG_AssetPickerOptions alloc]init];
    options.videoPickable = NO;
    options.maxAssetsCount = 3;
    NSMutableArray<XG_AssetModel *> *array = [self.assets mutableCopy];
    [array removeLastObject];//去除占位model
    options.pickedAssetModels = array;
    XG_AssetPickerController *photoPickerVc = [[XG_AssetPickerController alloc] initWithOptions:options delegate:self];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:photoPickerVc];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未开启相册权限，是否去设置中开启？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    [alert show];
}


- (void)onDeleteBtnClick:(UIButton *)sender{
    /*
     performBatchUpdates并不会调用代理方法collectionView: cellForItemAtIndexPath，
     如果用删除按钮的tag来标识则tag不会更新,所以此处没有用tag
     */
    SelectedAssetCell *cell = (SelectedAssetCell *)sender.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
        [self.assets removeObjectAtIndex:indexpath.item];
        [self.photoArr removeObjectAtIndex:indexpath.item];
        if (self.assets.count == 2 && ![self.assets containsObject:self.placeholderModel]) {
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:2 inSection:0]]];
            [self.assets addObject:self.placeholderModel];
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Network
- (void)getLawList
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_LawTypeList) parameters:@{} success:^(id success) {
            WeakSelf(ws);
            if (!kIsEmptyObj(success)) {
                ws.dataArr = [LawListModel mj_objectArrayWithKeyValuesArray:success[@"result"]];
                [self.view addSubview:self.chooseView];
 
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (void)getCompanyList
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_CompanyList) parameters:@{@"pageNum":@"1",@"pageSize":@"200"} success:^(id success) {
            WeakSelf(ws);
            if (!kIsEmptyObj(success)) {
                ws.comanyArr = [CompanyModel mj_objectArrayWithKeyValuesArray:success[@"result"]];
                [self.view addSubview:self.companyView];
                
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //取消
    }else{
        //去设置
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectedAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SelectedAssetCell class]) forIndexPath:indexPath];
    cell.model = self.assets[indexPath.item];
    [cell.deleteBtn addTarget:self action:@selector(onDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XG_AssetModel *model = self.assets[indexPath.item];
    if (model.isPlaceholder) {
        [self openAlbum];
    }
}

#pragma mark - XG_AssetPickerControllerDelegate

- (void)assetPickerController:(XG_AssetPickerController *)picker didFinishPickingAssets:(NSArray<XG_AssetModel *> *)assets{
    NSMutableArray *newAssets = assets.mutableCopy;
    if (newAssets.count < 3 ) {
        [newAssets addObject:self.placeholderModel];
    }
    self.assets = newAssets;
    
    [self.photoArr removeAllObjects];
    for (int i = 0; i < assets.count; i ++) {
        XG_AssetModel *model = assets[i];
        [[XG_AssetPickerManager manager] getPhotoWithAsset:model.asset photoWidth:kScreen_W completion:^(UIImage *photo, NSDictionary *info) {
            [self.photoArr addObject:photo];
        }];
    }
    [self.collectionView reloadData];
}


- (void)networkingForUploadImg:(NSArray *)imgArr
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
//    [dic setObject:@"800017" forKey:@"staffNo"];
    if ([_typeName.text containsString:@"企业"]) {
        [dic setObject:self.companyId forKey:@"companyId"];
        [dic setObject:@"" forKey:@"staffNo"];
    }
    else
    {
        [dic setObject:self.noLbl.text forKey:@"staffNo"];
        [dic setObject:@"" forKey:@"companyId"];
    }
   
    [dic setObject:[self selectData][0] forKey:@"lawType"];
    
    [dic setObject:self.content.text forKey:@"law"];
    [dic setObject:self.addressBtn.titleLabel.text forKey:@"lawAddress"];

    [dic setObject:[kUserDefaults objectForKey:@"mobile"] forKey:@"createPerson"];
    [dic setObject:@"1" forKey:@"channelType"];

    
    [Base_AFN_Manager post_images_url:IP_SPLICE(IP_Post_LawList) parameters:dic imageDatas:imgArr fileNameArr:@[@"file1",@"file2",@"file3"]  success:^(id success) {
    
        
        if ([success[@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccess:success[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showError:success[@"msg"]];
        }
        
    } failure_login:^(id failure) {

    } failure_data:^(id failure) {

    } error:^(id error) {

    }];
}


- (void)uploadDataWithImage:(NSArray *)imagesArray url:(NSString *)url filename:(NSString *)filename name:(NSString *)name    params:(NSDictionary *)params  success:(SuccessBlock)success fail:(FailureDataBlock)fail
{
    // 1. 设置网络管理者
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 4. 设置响应数据类型
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", @"application/x-javascript",@"image/png", nil]];
    
    
    // 5. UTF-8转码
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < imagesArray.count; i ++) {
            
            //压缩图片
            NSData *imageData = UIImageJPEGRepresentation(imagesArray[i], 0.5);
            NSString *imageFileName =filename;
            if (filename == nil || [filename isKindOfClass:[NSString class]] || filename.length == 0) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@.jpg",str];//以这种格式防止上传的图片重复覆盖
            }
            //上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"上传图片成功-%@",responseObject);
//        if (success) {
//            success(responseObject);
//        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
//        if (fail) {
//            fail(error);
//        }
        
    }];
}



- (NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray new];
    }
    return _photoArr;
}

- (SQChooseView *)typeView
{
    if (!_typeView) {
        _typeView = [[SQChooseView alloc]initWithFrame:kFrame(0, kScreen_H, kScreen_W, 45+70+44*2) type:2 title:@"类型" data:@[@"企业名称",@"骑手编号"] block:^(NSArray *arr) {
            self.selectTypeArr = arr;
            self.typeName.text = @[@"企业名称",@"骑手编号"][[arr[0] integerValue]];
            self.noLbl.placeholder = @[@"请选择企业",@"请输入骑手编号"][[arr[0] integerValue]];
            self.noLbl.text = @"";
            self.noImg.hidden = [arr[0] integerValue] == 0 ? NO : YES;
            self.noButton.hidden = [arr[0] integerValue] == 0 ? NO : YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.maskView.alpha = 0;
                self.typeView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*2);
            }];
            
        } closeBlock:^{
            [UIView animateWithDuration:0.2 animations:^{
                self.maskView.alpha = 0;
                self.typeView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*2);
            }];
        }];
    }
    return _typeView;
}

- (SQChooseView *)companyView
{
    if (!_companyView) {
        _companyView = [[SQChooseView alloc]initWithFrame:kFrame(0, kScreen_H, kScreen_W, 45+70+44*9.5) type:0 title:@"选择企业" data:self.comanyArr block:^(NSArray *arr) {
            self.selectTypeArr = arr;
            CompanyModel *model = self.comanyArr[[arr[0] integerValue]];
            self.noLbl.text = model.name;
            self.companyId = model.ID;
            [UIView animateWithDuration:0.2 animations:^{
                self.maskView.alpha = 0;
                self.companyView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*9.5);
            }];
            
        } closeBlock:^{
            [UIView animateWithDuration:0.2 animations:^{
                self.maskView.alpha = 0;
                self.companyView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*9.5);
            }];
        }];
    }
    return _companyView;
}

- (SQChooseView *)chooseView
{
    if (!_chooseView) {
        _chooseView = [[SQChooseView alloc]initWithFrame:kFrame(0, kScreen_H, kScreen_W, 45+70+44*9.5) type:1 title:@"违规类型(可多选)" data:self.dataArr block:^(NSArray *arr) {
            self.selectArr = arr;
            [self.typeBtn setTitle:[self selectData][1] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                self.maskView.alpha = 0;
                self.chooseView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*9.5);
            }];
            
        } closeBlock:^{
            [UIView animateWithDuration:0.2 animations:^{
                self.maskView.alpha = 0;
                self.chooseView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*9.5);
            }];
        }];
    }
    return _chooseView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]xx_initLineFrame:kFrame(0,0, kScreen_W, kScreen_H) color:kBlack];
        _maskView.alpha = 0;
        [_maskView xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [UIView animateWithDuration:0.2 animations:^{
                self.maskView.alpha = 0;
                self.chooseView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*9.5);
                self.typeView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*2);
                self.companyView.frame = kFrame(0, kScreen_H, kScreen_W, 45+70+44*9.5);
            }];
        }];
    }
    return _maskView;
}

#pragma mark - data
- (NSArray *)selectData
{
    NSArray *result = [self.selectArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
    }];
    
    NSString *str1;
    NSString *str2;
    for (int i = 0; i <result.count; i ++) {
        for (int j = 0; j <self.dataArr.count; j ++) {
            LawListModel *model = self.dataArr[j];
            NSLog(@"%ld",(long)[result[i] integerValue]);
            if ([result[i] integerValue] == model.ID-1) {
                if (kIsEmptyStr(str1)) {
                    str1 = kStrNum(model.ID);
                    str2 = model.content;
                }
                else
                {
                    str1 = [NSString stringWithFormat:@"%@,%@",str1,kStrNum(model.ID)];
                    str2 = [NSString stringWithFormat:@"%@;%@",str2,model.content];
                }
            }
        }
    }
    NSLog(@"result=%@",result);
    return @[str1,str2];
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



