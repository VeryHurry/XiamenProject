//
//  NSString+Verification.h
//  Product_Tea_180514
//
//  Created by betterda-zyqi on 2018/5/14.
//  Copyright © 2018年 ProductTea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)

- (BOOL)isEmptyStr;

//纯数字正则验证
- (BOOL)verifyNumber;

//手机号码正则验证
- (BOOL)verifyMobile;

//密码正则验证
- (BOOL)verifyPassword;

//卡片正则验证
- (BOOL)verifyBankCard;

//身份证正则验证
- (BOOL)verifyUserID;

@end
