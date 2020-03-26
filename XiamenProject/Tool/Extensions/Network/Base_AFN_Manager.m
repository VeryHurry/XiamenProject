//
//  Base_AFN_Manager.m
//  Afnetworking-Test
//
//  Created by betterda-zyqi on 2018/10/15.
//  Copyright © 2018年 betterda-zyqi. All rights reserved.
//

#import "Base_AFN_Manager.h"
#import "AFNetworking.h"
#import "MacroDefinition.h"

@implementation Base_AFN_Manager

/**  检测当前网络是够可用 **/
+ (BOOL)isNetworking {
    __block BOOL isNet = NO;
    // 打开网络监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里改变RunLoop模式
        CFRunLoopStop(CFRunLoopGetMain());
        //监测网络改变
        switch (status) {
            case AFNetworkReachabilityStatusUnknown://未知网络状态
                isNet = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable://无网络
                isNet = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://蜂窝数据网络
                isNet = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://WiFi网络
                isNet = YES;
                break;
                
            default:
                break;
        }
    }];
    // 关闭网络监测
//    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    //这里恢复RunLoop
    CFRunLoopRun();
    return isNet;
}

/**  单例 **/
static AFHTTPSessionManager *manager = nil;
static dispatch_once_t onceToken;
+ (AFHTTPSessionManager *)sharedManager {
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        //最大请求并发任务数
        manager.operationQueue.maxConcurrentOperationCount = 5;
        // 超时时间
        manager.requestSerializer.timeoutInterval = 60.f;
        //申明请求的数据类型
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //申明返回的结果类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    });
    
    return manager;
}

+ (void)getUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure_login:(FailureLoginBlock)failure_login failure_data:(FailureLoginBlock)failure_data error:(ErrorBlock)err {
    id params = [Base_AFN_Manager dealWithRequestByParams:parameters];
    [[Base_AFN_Manager sharedManager] GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [Base_AFN_Manager parseData:responseObject response:task.response result:^(id data) {
            NSLog(@"%@",urlString);
            success(data);
            
        }];
//        [Base_AFN_Manager clean];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        err(error);
//        [Base_AFN_Manager clean];
    }];
}

+ (void)postUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure_login:(FailureLoginBlock)failure_login failure_data:(FailureLoginBlock)failure_data error:(ErrorBlock)err {
    id params = [Base_AFN_Manager dealWithRequestByParams:parameters];
    [[Base_AFN_Manager sharedManager] POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [Base_AFN_Manager parseData:responseObject response:task.response result:^(id data) {
            
                success(data);
            
            
        }];
//        [Base_AFN_Manager clean];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        err(error);
//        [Base_AFN_Manager clean];
    }];
}

+ (void)post_images_url:(NSString *)urlString parameters:(NSDictionary *)parameters imageDatas:(NSArray *)imageDatas fileNameArr:(NSArray *)fileNameArr success:(SuccessBlock)success failure_login:(FailureLoginBlock)failure_login failure_data:(FailureLoginBlock)failure_data error:(ErrorBlock)err {
//    id params = [Base_AFN_Manager dealWithRequestByParams:parameters];
//    AFQueryStringFromParameters(parameters);
    [[Base_AFN_Manager sharedManager] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSArray *fileArr = @[@"file1",@"file2",@"file3"];
         for (int i = 0; i < imageDatas.count; i++) {
    
            NSData *data = UIImageJPEGRepresentation(imageDatas[i], 0.5);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:data name:fileNameArr[i] fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [Base_AFN_Manager parseData:responseObject response:task.response result:^( id data) {
            
                    success(data);
            
            
        }];
//        [Base_AFN_Manager clean];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        err(error);
//        [Base_AFN_Manager clean];
    }];
}




#pragma mark ---- 检查并处理参数
+ (id)dealWithRequestByParams:(NSDictionary *)params {
    if (params.count <= 0) {
        return nil;
    }
    NSArray *keys = params.allKeys;
    NSMutableString *bodyStr = [NSMutableString string];
    BOOL isEncrypted = NO;
    for (NSString *key in keys) {
        if (!IsEmptyObj([params valueForKey:key])) {
            if ([key isEqualToString:@"encrypted"]) {
                isEncrypted = YES;
                continue;
            }
            [bodyStr appendString:[NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]]];
        }
    }
    NSString *body = bodyStr;
    if (bodyStr.length > 1) {
        body = [bodyStr substringWithRange:NSMakeRange(0, bodyStr.length - 1)];
    }
    NSDictionary *data;
    if (isEncrypted) {
        data = @{@"data":body.encryptChineseByRSA,@"encrypted":@"Y"};
    }
    return isEncrypted ? data : params;
}

#pragma mark ---- 解析请求结果
+ (void)parseData:(NSData *)data response:(NSURLResponse *)response result:(void (^)(id data))result {
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//    NSString *firstNumber = [NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode];
//    if ([firstNumber hasPrefix:@"4"]) {
//        result(999, [NSString stringWithFormat:@"%@",firstNumber], @"");
//        NSLog(@"999---%@---%@",[NSString stringWithFormat:@"%@",firstNumber], @"");
//    }
//    if ([firstNumber hasPrefix:@"5"]) {
//        result(999, [NSString stringWithFormat:@"%@",firstNumber], @"");
//        NSLog(@"999---%@---%@",[NSString stringWithFormat:@"%@",firstNumber], @"");
//    }
//    if ([firstNumber hasPrefix:@"2"]) {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSLog(@"========%@", dic);
    result(dic);
//    }
}

#pragma mark ---- https证书
+ (AFSecurityPolicy *)customSecurityPolicy {
    //Https CA证书地址
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"HTTPSCer" ofType:@"cer"];
    //获取CA证书数据
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    //创建AFSecurityPolicy对象
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//AFSSLPinningModeCertificate
    //设置是否允许不信任的证书（证书无效、证书时间过期）通过验证 ，默认为NO.
    security.allowInvalidCertificates = YES;
    //是否验证域名证书的CN(common name)字段。默认值为YES。
    security.validatesDomainName = NO;
    //根据验证模式来返回用于验证服务器的证书
//    security.pinnedCertificates = [NSSet setWithObject:cerData];
    return security;
}

+ (void)clean {
    [[Base_AFN_Manager sharedManager]invalidateSessionCancelingTasks:YES];
    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
    manager = nil;
}

@end
