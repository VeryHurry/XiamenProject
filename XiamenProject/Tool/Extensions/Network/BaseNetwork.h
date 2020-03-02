//
//  BaseNetwork.h
//  Product_Tea_180514
//
//  Created by betterda-zyqi on 2018/5/14.
//  Copyright © 2018年 ProductTea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(void);
typedef void(^SuccessBlock)(id success);
typedef void(^FailureBlock)(id failure);
typedef void(^ErrorBlock)(id error);

@interface BaseNetwork : NSObject

#pragma mark -------------------- 网络请求（get） --------------------
/**
 网络请求（get）
 
 @param urlStr 请求路径
 @param params 参数（字典）
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @param errorBlock 错误回调
 @param completion 完成回调
 */
+ (void)getWithURL:(NSString *)urlStr parameters:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock error:(ErrorBlock)errorBlock completion:(CompletionBlock)completion;

#pragma mark -------------------- 网络请求（get）加密 --------------------
/**
 网络请求（get）加密
 
 @param urlStr 请求路径
 @param params 参数（字典）
 @param isEncrypted 是否加密
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @param errorBlock 错误回调
 @param completion 完成回调
 */
+ (void)getWithURL:(NSString *)urlStr parameters:(NSDictionary *)params isEncrypted:(BOOL)isEncrypted success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock error:(ErrorBlock)errorBlock completion:(CompletionBlock)completion;

#pragma mark -------------------- 网络请求（post）加密 --------------------
/**
 网络请求（post）加密
 
 @param urlStr 请求路径
 @param params 参数（字典）
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @param errorBlock 错误回调
 @param completion 完成回调
 */
+ (void)postWithURL:(NSString *)urlStr parameters:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock error:(ErrorBlock)errorBlock completion:(CompletionBlock)completion;

#pragma mark -------------------- 网络请求（post）加密 --------------------
/**
 网络请求（post）加密
 
 @param urlStr 请求路径
 @param params 参数（字典）
 @param isEncrypted 是否加密
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @param errorBlock 错误回调
 @param completion 完成回调
 */
+ (void)postWithURL:(NSString *)urlStr parameters:(NSDictionary *)params isEncrypted:(BOOL)isEncrypted success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock error:(ErrorBlock)errorBlock completion:(CompletionBlock)completion;

#pragma mark -------------------- 网络请求（session） --------------------
/**
 网络请求（session）
 
 @param request request
 @param success 成功回调
 @param failure 失败回调
 @param err 错误回调
 @param completion 完成回调
 */
- (void)sessionByRequset:(NSMutableURLRequest *)request success:(SuccessBlock)success failure:(FailureBlock)failure error:(ErrorBlock)err completion:(CompletionBlock)completion;

#pragma mark -------------------- 取消网络请求 --------------------
+ (void)cancel;
@end
