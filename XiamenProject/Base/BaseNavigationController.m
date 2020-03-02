//
//  BaseNavigationController.m
//  ZhiFu
//
//  Created by OSX on 2017/10/23.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MacroDefinition.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBar.shadowImage = [UIImage new];//消除阴影
//    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = kWhite;
    self.navigationBar.titleTextAttributes = NavigationTitleDic;
//    [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self.view endEditing:YES];
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
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
