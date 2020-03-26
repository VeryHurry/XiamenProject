//
//  SQMineViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/25.
//  Copyright © 2019 MacStudent. All rights reserved.
//
#import <Photos/Photos.h>
#import "SQMineViewController.h"
#import "SQSetViewController.h"
#import "SQLoginViewController.h"
#import "SQVehicleManagementViewController.h"
#import "MacroDefinition.h"
#import "UserModel.h"
#import "MyVehicleModel.h"
#import "SQMyGarageCell.h"
#import "UIImageView+WebCache.h"

@interface SQMineViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) MyVehicleModel *model;
@property (nonatomic, strong) NSDictionary *vehicleDic;//车辆信息

@end

@implementation SQMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SQMyGarageCell" bundle:nil] forCellReuseIdentifier:@"myGarage_cell"];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self isLogin];
    if ([kUserDefaults objectForKey:@"mobile"]&&!kIsEmptyStr([kUserDefaults objectForKey:@"mobile"])) {
        [self getMessage];
        [self getMyGarage];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)isLogin
{
    if (![UserDefaultsTool getBoolForKey:@"isLogin"]) {
        SQLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"login_sb"];
        loginVC.modalPresentationStyle = 0;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)updateUI
{
    _name.text = _userModel.name;
    _type.text = _userModel.type == 1 ?@"普通用户":@"";
    if (kIsEmptyStr(_userModel.headImg)) {
        _userImage.image = [UIImage imageNamed:@"me_bt_head"];
    }
    else
    {
       [_userImage sd_setImageWithURL:kImageUrl(_userModel.headImg) placeholderImage:[UIImage imageNamed:@"me_bt_head"]];
    }
    [_userImage xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){//用户之前已经授权
            [self changePhoto];
        }else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied){//用户之前已经拒绝授权
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您之前拒绝了访问相册，请到手机隐私设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertC addAction:sureAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }else{//弹窗授权时监听
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized){//允许
                    [self changePhoto];
                }else{//拒绝
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
        
        
    }];
}

- (void)changePhoto
{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        PickerImage.modalPresentationStyle = 0;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    dispatch_async(dispatch_get_main_queue(), ^{
       [self presentViewController:alert animated:YES completion:nil];
    });
    
    
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self updateHeadImg:newPhoto];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Network
- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_UserInfo) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"]} success:^(id success) {
            if (!kIsEmptyObj(success)) {
                self.userModel = [UserModel mj_objectWithKeyValues:success[@"result"]];
                [self.userModel saveModelWithPath:@"userinfo"];
                [self updateUI];
            }
            
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
}

- (void)getMyGarage
{
    
    [Base_AFN_Manager postUrl:IP_SPLICE(IP_BindStatus) parameters:@{@"mobile":[kUserDefaults objectForKey:@"mobile"],@"pageNum":@"0",@"pageSize":@"20"} success:^(id success) {
        self.model = [MyVehicleModel mj_objectWithKeyValues:success];
        [self.tableView reloadData];
        if (self.model.total > 0) {
            result *model = self.model.result[0];
            self.vehicleDic = @{@"imeiNo": model.imeiNo,@"vehicleNo": kIsEmptyStr(model.vehicleNo)? @" ":model.vehicleNo};
        }
        
    } failure_login:nil failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
    
}

- (void)updateHeadImg:(UIImage *)img
{
    NSArray *arr = [NSArray arrayWithObject:img];
    [Base_AFN_Manager post_images_url:IP_SPLICECAR(IP_UploadHead) parameters:@{@"id": _userModel.ID} imageDatas:arr fileNameArr:@[@"headImg"] success:^(id success) {
        NSLog(@"1111");
        self.userImage.image = img;
        [MBProgressHUD showSuccess:@"修改成功"];
    } failure_login:^(id failure) {
        
    } failure_data:^(id failure) {
        
    } error:^(id error) {
        
    }];
}

- (IBAction)set:(id)sender
{
    SQSetViewController *vc = [SQSetViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.model = _userModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SQVehicleManagementViewController *vc = [SQVehicleManagementViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    result *model = self.model.result[indexPath.row];
    vc.imeiNo = model.imeiNo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SQMyGarageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myGarage_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    result *model = self.model.result[indexPath.row];
    [cell setData:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.result.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}


#pragma mark - 懒加载
- (UITableView*)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:kFrame(0, 288, kScreen_W, kScreen_H-288-TabBar_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
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

