//
//  AlertTool.m
//  ZhiFu
//
//  Created by OSX on 17/6/15.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "AlertTool.h"

#define AlertShowTime 2.0
#define ActionSheetShowTime 1.0

#define TITLE Localized(@"提示")
#define OK Localized(@"确定")
#define CANCEL Localized(@"取消")

@implementation AlertTool

//alert
+ (void)showOKAlertWith:(UIViewController *)viewController message:(NSString *)message callbackBlock:(CallBackBlock)block {
    [self showAlertWith:viewController title:TITLE message:message cancelButtonTitle:OK destructiveButtonTitle:nil otherButtonTitles:nil callbackBlock:block];
}

+ (void)showCancelAlertWith:(UIViewController *)viewController message:(NSString *)message callbackBlock:(CallBackBlock)block {
    [self showAlertWith:viewController title:TITLE message:message cancelButtonTitle:CANCEL destructiveButtonTitle:nil otherButtonTitles:nil callbackBlock:block];
}

+ (void)showDefaultAlertWith:(UIViewController *)viewController message:(NSString *)message callbackBlock:(CallBackBlock)block {
    [self showAlertWith:viewController title:TITLE message:message cancelButtonTitle:CANCEL destructiveButtonTitle:nil otherButtonTitles:@[OK] callbackBlock:block];
}

+ (void)showAlertWith:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherButtonTitles callbackBlock:(CallBackBlock)block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self alertController:alertController viewController:viewController title:title message:message cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:otherButtonTitles callbackBlock:block type:@"Alert"];
}

//actionSheet
+ (void)showActionSheetWith:(UIViewController *)viewController message:(NSString *)message {
    [self showActionSheetWith:viewController title:nil message:message cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil callbackBlock:nil];
}

+ (void)showActionSheetWith:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherButtonTitles callbackBlock:(CallBackBlock)block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self alertController:alertController viewController:viewController title:title message:message cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:otherButtonTitles callbackBlock:block type:@"ActionSheet"];
}

//textAlert
+ (void)showAlertTextFieldWith:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message textFieldPlaceholder:(NSString *)placeholder cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherButtonTitles callbackBlock:(CallTextBackBlock)block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
        textField.textColor = [UIColor blackColor];
//        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textField.backgroundColor = [UIColor clearColor];
//        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [self alertController:alertController viewController:viewController title:title message:message cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:otherButtonTitles callTextbackBlock:block type:@"Alert"];
}

//alert、actionSheet添加按钮
+ (void)alertController:(UIAlertController *)alertController viewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherButtonTitles callbackBlock:(CallBackBlock)block type:(NSString *)type {
    UIAlertAction *singleAction = nil;
    //添加按钮
    if (cancelBtnTitle) {
        singleAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (block) {
                 block(0);
            }
        }];
        [alertController addAction:singleAction];
    }
    if (destructiveBtnTitle) {
        singleAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            if (block) {
                block(-1);
            }
        }];
        [alertController addAction:singleAction];
    }
    if (otherButtonTitles) {
        for (int i = 0; i < otherButtonTitles.count; i++) {
            singleAction = [UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (block) {
                    block(i + 1);
                }
            }];
            [alertController addAction:singleAction];
        }
    }
    [self presentViewController:alertController viewController:viewController cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:otherButtonTitles type:type];
}

//textAlert添加按钮
+ (void)alertController:(UIAlertController *)alertController viewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherButtonTitles callTextbackBlock:(CallTextBackBlock)block type:(NSString *)type {
    UIAlertAction *singleAction = nil;
    //添加按钮
    if (cancelBtnTitle) {
        singleAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (block) {
                block(0,nil);
            }
        }];
        [alertController addAction:singleAction];
    }
    if (destructiveBtnTitle) {
        singleAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            if (block) {
                block(-1,nil);
            }
        }];
        [alertController addAction:singleAction];
    }
    if (otherButtonTitles) {
        for (int i = 0; i < otherButtonTitles.count; i++) {
            singleAction = [UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (block) {
                    block(i + 1,alertController.textFields.firstObject.text);
                }
            }];
            [alertController addAction:singleAction];
        }
    }
    [self presentViewController:alertController viewController:viewController cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:otherButtonTitles type:type];
}

 + (void)presentViewController:(UIViewController *)alertController viewController:(UIViewController *)viewController cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherButtonTitles type:(NSString *)type {
    [viewController presentViewController:alertController animated:YES completion:nil];
    if (IsEmptyStr(cancelBtnTitle) && IsEmptyStr(destructiveBtnTitle) && otherButtonTitles.count <= 0) {
        if ([type isEqualToString:@"Alert"]) {
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertShowTime];
        } else if ([type isEqualToString:@"ActionSheet"]) {
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:ActionSheetShowTime];
        }
    }
}

+ (void)dismissAlertController:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:nil];
}
@end
