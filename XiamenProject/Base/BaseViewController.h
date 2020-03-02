//
//  Base_ViewController.h
//  BaseFrame
//
//  Created by betterda-zyqi on 2018/5/10.
//  Copyright © 2018年 BaseFrame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+NavigationBarHidden.h"

@interface BaseViewController : UIViewController

/**
 返回按钮
 
 默认的返回箭头，如需修改，可设置 leftTitleArray 属性。
 */
@property (nonatomic, assign) BOOL isBack;//返回箭头

/** 修改默认返回箭头的颜色 **/
@property (nonatomic, strong) UIColor *backColor;

/** title的标签字体 **/
@property (nonatomic, strong) UIFont *titleFont;

/** title的标签颜色 **/
@property (nonatomic, strong) UIColor *titleColor;

/** leftItems的标签数组 **/
@property (nonatomic, strong) NSArray<NSString *> *leftTitleArray;

/** leftItems的标签颜色 **/
@property (nonatomic, strong) UIColor *leftTitleColor;

/** leftItems的标签字体 **/
@property (nonatomic, strong) UIFont *leftTitleFont;

/** rightItems的标签数组 **/
@property (nonatomic, strong) NSArray<NSString *> *rightTitleArray;

/** rightItems的标签颜色 **/
@property (nonatomic, strong) UIColor *rightTitleColor;

/** rightItems的标签字体 **/
@property (nonatomic, strong) UIFont *rightTitleFont;

/** 系统默认leftItem **/
@property (nonatomic) UIBarButtonSystemItem systemLeftItem;

/** 系统默认leftItem的颜色 **/
@property (nonatomic, strong) UIColor *systemLeftItemColor;

/** 系统默认rightItem **/
@property (nonatomic) UIBarButtonSystemItem systemRightItem;

/** 系统默认rightItem的颜色 **/
@property (nonatomic, strong) UIColor *systemRightItemColor;

/** leftItems的自定义标签的图标数组 **/
@property (nonatomic, strong) NSArray<UIImage *> *leftImageArray;

/** leftImageItems的标签颜色 **/
@property (nonatomic, strong) UIColor *leftImageColor;

/** rightItems的自定义标签的图标数组 **/
@property (nonatomic, strong) NSArray<UIImage *> *rightImageArray;

/** rightImageItems的标签颜色 **/
@property (nonatomic, strong) UIColor *rightImageColor;

/** leftItems的自定义标签的按钮数组 **/
@property (nonatomic, strong) NSArray<UIView *> *leftViewArray;

/** rightItems的自定义标签的按钮数组 **/
@property (nonatomic, strong) NSArray<UIView *> *rightViewArray;

/** 是否监听键盘 **/
@property (nonatomic) BOOL isNotificationKeyboard;

/**
 重写item的点击事件
 */
- (void)back;
- (void)leftItemClick:(UIBarButtonItem *)item;
- (void)rightItemClick:(UIBarButtonItem *)item;
- (void)reversePush:(UIViewController *)toViewController;
- (void)reversePop;



@end
