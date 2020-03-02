//
//  BaseNetwork.m
//  Product_Tea_180514
//
//  Created by betterda-zyqi on 2018/5/14.
//  Copyright © 2018年 ProductTea. All rights reserved.
//

#import "BaseNetwork.h"
#import "MacroDefinition.h"

//1.声明一个空的静态的单例对象
static BaseNetwork *_baseNetwork = nil;
//2.声明一个静态的gcd的单次任务
static dispatch_once_t oneToken;

@interface BaseNetwork()<NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSMutableArray *taskArray;//记录发起请求的task;
@end

@implementation BaseNetwork

+ (BaseNetwork *)sharedSingleton {
    //3.执行gcd单次任务：对对象进行初始化
    dispatch_once(&oneToken, ^{
        _baseNetwork = [[BaseNetwork alloc]init];
    });
    
    return _baseNetwork;
}

- (NSMutableArray *)taskArray {
    if (!_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

//处理参数
+ (NSString *)dealWithRequestbyParams:(NSDictionary *)params {
    //处理请求参数
    NSArray *keys = params.allKeys;
    NSMutableString *bodyStr = [NSMutableString string];
    for (NSString *key in keys) {
        if (!IsEmptyObj([params valueForKey:key])) {
            [bodyStr appendString:[NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]]];
            if ([key isEqualToString:@"encrypted"]) {
                [bodyStr appendString:[NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]]];
            }
        }
    }
    NSString *body;
    if (bodyStr.length > 1) {
        body = [bodyStr substringWithRange:NSMakeRange(0, bodyStr.length - 1)];
    } else {
        body = bodyStr;
    }
    return body;
}

+ (void)getWithURL:(NSString *)urlStr parameters:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock error:(ErrorBlock)errorBlock completion:(CompletionBlock)completion {
    
    [BaseNetwork getWithURL:urlStr parameters:params isEncrypted:NO success:^(id success) {
        if (successBlock) {
            successBlock(success);
        }
    } failure:^( id failure) {
        if (failureBlock) {
            failureBlock(failure);
        }
    } error:^(id error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } completion:^{
        if (completion) {
            completion();
        }
    }];
}

+ (void)getWithURL:(NSString *)urlStr parameters:(NSDictionary *)params isEncrypted:(BOOL)isEncrypted success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock error:(ErrorBlock)errorBlock completion:(CompletionBlock)completion {
    NSString *body = [BaseNetwork dealWithRequestbyParams:params];
    //拼接路径
    NSURL *url;
    if (isEncrypted) {
        body = [BaseNetwork dealWithRequestbyParams:params];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?data=%@&encrypted=Y",IP,urlStr,body.encryptChineseByRSA]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",IP,urlStr,body]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    BaseNetwork *net = [[BaseNetwork alloc]init];
    [net sessionByRequset:request success:^(id success) {
        if (successBlock) {
            successBlock(success);
        }
    } failure:^(id failure) {
        if (failureBlock) {
            failureBlock(failure);
        }
    } error:^(id error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } completion:^{
        if (completion) {
            completion();
        }
    }];
}

+ (void)postWithURL:(NSString *)urlStr parameters:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock error:(ErrorBlock)errorBlock completion:(CompletionBlock)completion {
    
    [BaseNetwork postWithURL:urlStr parameters:params isEncrypted:NO success:^(id success) {
        if (successBlock) {
            successBlock(success);
        }
    } failure:^(id failure) {
        if (failureBlock) {
            failureBlock(failure);
        }
    } error:^(id error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } completion:^{
        if (completion) {
            completion();
        }
    }];
}

+ (void)postWithURL:(NSString *)urlStr parameters:(NSDictionary *)params isEncrypted:(BOOL)isEncrypted success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock error:(ErrorBlock)errorBlock completion:(CompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *body;
    if (isEncrypted) {
        NSString *str = [BaseNetwork dealWithRequestbyParams:params];
        body = [NSString stringWithFormat:@"data=%@&encrypted=%@",str.encryptChineseByRSA,@"Y"];
    } else {
        body = [BaseNetwork dealWithRequestbyParams:params];
    }
    
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"post"];
    [request setHTTPBody:bodyData];
    
    BaseNetwork *net = [[BaseNetwork alloc]init];
    [net sessionByRequset:request success:^(id success) {
        if (successBlock) {
            successBlock(success);
        }
    } failure:^(id failure) {
        if (failureBlock) {
            failureBlock(failure);
        }
    } error:^(id error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } completion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)sessionByRequset:(NSMutableURLRequest *)request success:(SuccessBlock)success failure:(FailureBlock)failure error:(ErrorBlock)err completion:(CompletionBlock)completion {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                err(error);
                NSLog(@"%@",[NSString stringWithFormat:@"错误代码：%ld,错误信息：%@,失败原因：%@",(long)error.code, error.userInfo, error.localizedFailureReason]);
            } else {
                [BaseNetwork parseRequestData:data response:response result:^(int code, NSString *resultMsg, id data) {
                    switch (code) {
                        case 0:
                            if (failure) {
                                failure(data);
                            }
                            break;
                        case 1:
                            if (success) {
                                success(data);
                            }
                            break;
                        case 2:
                            if (failure) {
                                failure(data);
                            }
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
        });
        dispatch_group_leave(group);
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
    [task resume];
    [[BaseNetwork sharedSingleton].taskArray addObject:task];
}

#pragma mark -------------------- NSURLSessionDelegate --------------------
/*
 只要请求的地址是HTTPS的, 就会调用这个代理方法
 我们需要在该方法中告诉系统, 是否信任服务器返回的证书
 Challenge: 挑战 质问 (包含了受保护的区域)
 protectionSpace : 受保护区域
 NSURLAuthenticationMethodServerTrust : 证书的类型是 服务器信任
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if(![challenge.protectionSpace.authenticationMethod isEqualToString:@"NSURLAuthenticationMethodServerTrust"]) {
        return;
    }
    NSLog(@"%@",challenge.protectionSpace);
    //NSURLSessionAuthChallengeDisposition 如何处理证书
    /*
     NSURLSessionAuthChallengeUseCredential = 0, 使用该证书 安装该证书
     NSURLSessionAuthChallengePerformDefaultHandling = 1, 默认采用的方式,该证书被忽略
     NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2, 取消请求,证书忽略
     NSURLSessionAuthChallengeRejectProtectionSpace = 3,          拒绝
     */
    NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
    
    //NSURLCredential 授权信息
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}

+ (void)parseRequestData:(NSData *)data response:(NSURLResponse *)response result:(void (^)(int code, NSString *resultMsg, id data))result {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSString *firstNumber = [NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode];
    if ([firstNumber hasPrefix:@"4"]) {
        result(2, [NSString stringWithFormat:@"请求错误:%@",firstNumber], @"");
        NSLog(@"2---%@---%@",[NSString stringWithFormat:@"请求错误:%@",firstNumber], @"");
    }
    if ([firstNumber hasPrefix:@"5"]) {
        result(2, [NSString stringWithFormat:@"服务器错误:%@",firstNumber], @"");
        NSLog(@"2---%@---%@",[NSString stringWithFormat:@"服务器错误:%@",firstNumber], @"");
    }
    if ([firstNumber hasPrefix:@"2"]) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%d---%@---%@",[dic[@"code"] intValue],dic[@"resultMsg"],dic[@"data"]);
        result([dic[@"code"] intValue],HandleStr(dic[@"resultMsg"]),HandleObj(dic[@"data"]));
        return ;
    }
    
}

#pragma mark -------------------- 取消网络请求 --------------------
+ (void)cancel {
    for (int i = 0; i < [BaseNetwork sharedSingleton].taskArray.count; i++) {
        [[BaseNetwork sharedSingleton].taskArray[i] cancel];
    }
}

- (void)dealloc {
    NSLog(@"---%@---BaseNetwokDealloc---",self);
}

@end
