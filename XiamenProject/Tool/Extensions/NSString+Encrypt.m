//
//  NSString+Encrypt.m
//  ZhiFu
//
//  Created by OSX on 2017/9/13.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "NSString+Encrypt.h"
#import "RSA.h"



@implementation NSString (Encrypt)

- (NSString *)encryptByRSA {
    return [RSA encryptString:self publicKey:PUBLICKEY].tuoYi;
}

- (NSString *)encryptChineseByRSA {
    return [RSA encryptString:self.tuoYi publicKey:PUBLICKEY];
    
}

- (NSString *)tuoYi {
//    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#.[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)self, nil,(CFStringRef)@"!*'();:@+=&$,/?%#[] ", kCFStringEncodingUTF8));
}
@end
