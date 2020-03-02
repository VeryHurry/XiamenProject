//
//  AlertTool.h
//  ZhiFu
//
//  Created by OSX on 17/6/15.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacroDefinition.h"
/**
 *  回调block
 */
typedef void (^CallBackBlock)(NSInteger btnIndex);
typedef void (^CallTextBackBlock)(NSInteger btnIndex, NSString *text);
typedef void(^Block)(void);

typedef NS_ENUM(NSInteger, AlertActionStyle) {
    AlertActionStyleDefault = 0,
    AlertActionStyleCancel,
    AlertActionStyleDestructive,
    AlertActionStyleNone
};

@interface AlertTool : NSObject

/**
 alert

 @param viewController alert的父视图
 @param message 内容
 @param block 选中按钮事件处理
 */
+ (void)showOKAlertWith:(UIViewController *)viewController message:(NSString *)message callbackBlock:(CallBackBlock)block;
+ (void)showCancelAlertWith:(UIViewController *)viewController message:(NSString *)message callbackBlock:(CallBackBlock)block;
+ (void)showDefaultAlertWith:(UIViewController *)viewController message:(NSString *)message callbackBlock:(CallBackBlock)block;

/**
 alert
 
 @param viewController alert的父视图
 @param title 标题
 @param message 内容
 @param cancelBtnTitle 取消按钮标题
 @param destructiveBtnTitle 警告按钮标题
 @param otherButtonTitles 其他按钮标题
 @param block 选中按钮事件处理
 */
+ (void)showAlertWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelBtnTitle
destructiveButtonTitle:(NSString *)destructiveBtnTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
                callbackBlock:(CallBackBlock)block;

/**
 actionSheet
 
 @param viewController alert的父视图
 @param message 内容
 */
+ (void)showActionSheetWith:(UIViewController *)viewController message:(NSString *)message;

/**
 actionSheet
 
 @param viewController alert的父视图
 @param title 标题
 @param message 内容
 @param cancelBtnTitle 取消按钮标题
 @param destructiveBtnTitle 警告按钮标题
 @param otherButtonTitles 其他按钮标题
 @param block 选中按钮事件处理
 */
+ (void)showActionSheetWith:(UIViewController *)viewController
                  title:(NSString *)title
                message:(NSString *)message
          cancelButtonTitle:(NSString *)cancelBtnTitle
     destructiveButtonTitle:(NSString *)destructiveBtnTitle
          otherButtonTitles:(NSArray *)otherButtonTitles
              callbackBlock:(CallBackBlock)block;

/**
 textAlert
 
 @param viewController alert的父视图
 @param title 标题
 @param message 内容
 @param placeholder 文本框
 @param cancelBtnTitle 取消按钮标题
 @param destructiveBtnTitle 警告按钮标题
 @param otherButtonTitles 其他按钮标题
 @param block 选中按钮事件处理
 */
+ (void)showAlertTextFieldWith:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message textFieldPlaceholder:(NSString *)placeholder cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherButtonTitles callbackBlock:(CallTextBackBlock)block;

@end
