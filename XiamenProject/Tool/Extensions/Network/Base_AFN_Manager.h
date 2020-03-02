//
//  Base_AFN_Manager.h
//  Afnetworking-Test
//
//  Created by betterda-zyqi on 2018/10/15.
//  Copyright © 2018年 betterda-zyqi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id success);//请求成功code：1
typedef void(^FailureLoginBlock)(id failure);//请求成功code：0
typedef void(^FailureDataBlock)(id failure);//请求成功code：2
typedef void(^ErrorBlock)(id error);//请求失败

@interface Base_AFN_Manager : NSObject

/**
 检测当前网络是够可用
 
 @return 网络是否可用
 */
+ (BOOL)isNetworking;

/**
 get请求
 
 @param urlString 路径
 @param parameters 参数（key:value）
 @param success 成功回调
 @param failure_login 为登录回调
 @param failure_data 失败回调
 @param err 错误回调
 */
+ (void)getUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure_login:(FailureLoginBlock)failure_login failure_data:(FailureLoginBlock)failure_data error:(ErrorBlock)err;

/**
 post请求

 @param urlString 路径
 @param parameters 参数（key:value）
 @param success 成功回调
 @param failure_login 为登录回调
 @param failure_data 失败回调
 @param err 错误回调
 */
+ (void)postUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure_login:(FailureLoginBlock)failure_login failure_data:(FailureLoginBlock)failure_data error:(ErrorBlock)err;

/**
 post上传图片
 
 @param urlString 路径
 @param parameters 参数（key:value）
 @param imageDatas 图片数组
 @param success 成功回调
 @param failure_login 为登录回调
 @param failure_data 失败回调
 @param err 错误回调
 */
+ (void)post_images_url:(NSString *)urlString parameters:(NSDictionary *)parameters imageDatas:(NSArray<NSData *> *)imageDatas success:(SuccessBlock)success failure_login:(FailureLoginBlock)failure_login failure_data:(FailureLoginBlock)failure_data error:(ErrorBlock)err;

/**
 清除网络请求
 */
+ (void)clean;
@end
