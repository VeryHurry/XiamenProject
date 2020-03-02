//
//  NSString+Encrypt.h
//  ZhiFu
//
//  Created by OSX on 2017/9/13.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PUBLICKEY @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCCpe4a3z4QDRdmURkf4wVKsVFHEZV3lNpAHv6LolRgpljGCSNTbdIT5pMUgLmw0OEoF1Dz934V7+sXubI8kK284bauHhZfmt4X2eU8nK4+coaiWmTeUpYVSTtQK7uv3ez3xRAhZZwk8pYQTtgKw1J5oEDiQsrIu7+SzcJURALrNwIDAQAB-----END PUBLIC KEY-----"

@interface NSString (Encrypt)

//RSA加密
- (NSString *)encryptByRSA;

//RSA中文加密
- (NSString *)encryptChineseByRSA;

//中文转义
- (NSString *)tuoYi;
@end
