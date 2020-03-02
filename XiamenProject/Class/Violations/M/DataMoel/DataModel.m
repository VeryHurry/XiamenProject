//
//  DataModel.m
//  MTTWallet
//
//  Created by mtt on 2017/3/17.
//  Copyright © 2017年 mtt. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

//获取未加密数据
+(void)getDataWithURL:(NSString *)url parameters:(NSDictionary *)parameters returnBlock:(void (^)(NSDictionary *))dataBlock
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" , @"text/plain; charset=utf-8", nil];
    manager.requestSerializer.timeoutInterval = 30.0f;
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:nil];
//        NSLog(@"%@",result);
        if (dataBlock) {
            dataBlock(result);
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSString *errorS=[NSString stringWithFormat:@"%@",error];
        
        if([errorS rangeOfString:@"code: 404"].location !=NSNotFound)//_roaldSearchText
        {
            [MBProgressHUD showMessag:@"服务器升级中，请稍后." toView:kWindow andShowTime:1];
        }
        else
        {
            [MBProgressHUD showMessag:@"服务器繁忙，请稍后再试" toView:kWindow andShowTime:1];
        }

        NSLog(@"请求失败，失败原因：%@",error);
        
    }];
    
}

+(void)getBasedDataWithURL:(NSString *)url parameters:(NSDictionary *)parameters returnBlock:(void (^)(NSDictionary *))dataBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" , @"text/plain; charset=utf-8", nil];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData *data = [[NSData alloc]initWithBase64EncodedData:responseObject options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];

        if (dataBlock) {
            dataBlock(result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败，失败原因：%@",error);
    }];

}


@end
