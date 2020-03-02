//
//  SQSetViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/26.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQSetViewController.h"
#import "SQRegistMessageViewController.h"
#import "SQSetNewPSWViewController.h"
#import "SDImageCache.h"
#import "MacroDefinition.h"

@interface SQSetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end

@implementation SQSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.title = @"设置";
    [self getFileSize];
}

- (void)getFileSize
{
//    //计算结果
//    CGFloat totalSize = 0;
//
//    // 构建需要计算大小的文件或文件夹的路径，这里以Documents为例
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//
//    // 1.获得文件夹管理者
//    NSFileManager *mgr = [NSFileManager defaultManager];
//
//    // 2.检测路径的合理性
//    BOOL dir = NO;
//    BOOL exits = [mgr fileExistsAtPath:path isDirectory:&dir];
//    if (!exits)
//    {
//        totalSize = 0;
//    }
//
//    // 3.判断是否为文件夹
//    if (dir)//文件夹, 遍历文件夹里面的所有文件
//    {
//        //这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径),包括子文件夹下面的所有文件及文件夹
//        NSArray *subPaths = [mgr subpathsAtPath:path];
//
//        //遍历所有子路径
//        for (NSString *subPath in subPaths)
//        {
//            //拼成全路径
//            NSString *fullSubPath = [path stringByAppendingPathComponent:subPath];
//
//            BOOL dir = NO;
//            [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
//            if (!dir)//子路径是个文件
//            {
//                //如果是数据库文件，不加入计算
//                if ([subPath isEqualToString:@"mySql.sqlite"])
//                {
//                    continue;
//                }
//                NSDictionary *attrs = [mgr attributesOfItemAtPath:fullSubPath error:nil];
//                totalSize += [attrs[NSFileSize] intValue];
//            }
//        }
//        totalSize = totalSize / (1024 * 1024.0);//单位M
//    }
//    else//文件
//    {
//        NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
//        totalSize = [attrs[NSFileSize] intValue] / (1024 * 1024.0);//单位M
//    }
    CGFloat size = [SDImageCache sharedImageCache].getSize;
    if (size >0) {
        self.cacheSize.text = [NSString stringWithFormat:@"%.2fMB",size/1000/1000];
        self.clearBtn.userInteractionEnabled = YES;
    }
    else
    {
        self.cacheSize.text = [NSString stringWithFormat:@"0MB"];
        self.clearBtn.userInteractionEnabled = NO;
    }
    
}

- (IBAction)userInfo:(id)sender
{
    SQRegistMessageViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"setMessage_sb"];
    vc.type = 0;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)change:(id)sender
{
    SQSetNewPSWViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"setNewPSW_sb"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)clear:(id)sender
{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        self.cacheSize.text = [NSString stringWithFormat:@"0MB"];
        [MBProgressHUD showSuccess:@"清理完成"];
        self.clearBtn.userInteractionEnabled = NO;
    }];
}

- (IBAction)logout:(id)sender
{
    [kUserDefaults removeObjectForKey:@"mobile"];
    [kUserDefaults removeObjectForKey:@"isLogin"];
    [self.navigationController popViewControllerAnimated:YES];
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
