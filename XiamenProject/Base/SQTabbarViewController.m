//
//  SQTabbarViewController.m
//  LeTu
//
//  Created by MacStudent on 2019/5/8.
//  Copyright © 2019 mtt. All rights reserved.
//

#import "SQTabbarViewController.h"
#import "MacroDefinition.h"
#import "SQHomeViewController.h"
#import "SQMyTrackViewController.h"
#import "SQMineViewController.h"
#import "BaseNavigationController.h"

@interface SQTabbarViewController ()<UITabBarDelegate>

@end

@implementation SQTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    // 设置 TabBarItemTestAttributes 的颜色。
    [self setUpTabBarItemTextAttributes];
    
    // 设置子控制器
    [self setUpChildViewController];
    
    //选中tabbar第一个item
    self.selectedIndex = 0;
    
    
}

#pragma mark -------------------- 设置tabbar上文字、图片 --------------------
- (void)setUpTabBarItemTextAttributes {
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = kGray;
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = Home_Text_Color;
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

#pragma mark -------------------- 添加子控制器 --------------------
- (void)setUpChildViewController {
    [self addOneChildViewController:[[SQHomeViewController alloc]init]
                          WithTitle:@"首页"
                          imageName:@"home_default"
                  selectedImageName:@"home_select"];
    [self addOneChildViewController:[[SQMyTrackViewController alloc]init]
                          WithTitle:@"行程"
                          imageName:@"home_friend"
                  selectedImageName:@"home_friend_select"];

    [self addOneChildViewController:[[SQMineViewController alloc]init]
                          WithTitle:@"我的"
                          imageName:@"home_me"
                  selectedImageName:@"home_me_select"];
    
}

- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:viewController];
    [self addChildViewController:navi];
}

#pragma mark -------------------- tabbarItem点击事件 --------------------
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject:item];
    [self addAnimationToIndex:index];
}

#pragma mark -------------------- tabbarItem抖动动画 --------------------
- (void)addAnimationToIndex:(NSInteger)index{
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CAKeyframeAnimation *bounceAnimation = [[CAKeyframeAnimation alloc] init];
    bounceAnimation.keyPath = @"transform.scale";
    bounceAnimation.values = @[@1.0 ,@1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = 0.6;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [[tabbarbuttonArray[index] layer] addAnimation:bounceAnimation forKey:@"TabBarItemAnimation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
