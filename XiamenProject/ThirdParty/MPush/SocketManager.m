//
//  SocketManager.m
//  LeTu
//
//  Created by mtt on 2017/10/18.
//  Copyright © 2017年 mtt. All rights reserved.
//

#import "SocketManager.h"

@implementation SocketManager

+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    static  SocketManager *socketMrg = nil;
    dispatch_once(&onceToken, ^{
        socketMrg = [[self alloc] init];
        [socketMrg initSocket];
    });
    return socketMrg;
}

- (void)initSocket
{
    //1.初始化GCDAsyncSocket 并设置 代理 与 代理线程
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (NSMutableData *)messageBodyData{
    
    if (_messageBodyData == nil) {
        _messageBodyData = [[NSMutableData alloc] init];
    }
    return _messageBodyData;
}

- (NSMutableArray *)messages{
    if (_messages == nil) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages ;
}

#pragma mark - 连接到网络
-(void)connectToHost
{
    
    // 获取分配的 主机ip 和 端口号
    NSString *urlStr = [NSString stringWithFormat:@"%@",CARIP];
    AFHTTPSessionManager *mng = [AFHTTPSessionManager manager];
    mng.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
    [mng.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    mng.requestSerializer= [AFHTTPRequestSerializer serializer];
    mng.responseSerializer= [AFHTTPResponseSerializer serializer];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    [mng.requestSerializer setValue:currentVersion forHTTPHeaderField:@"version"];
    [mng GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseObjectStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (responseObjectStr.length < 3) {
            return ;
        }
        NSArray *hostArr = [responseObjectStr componentsSeparatedByString:@":"];
        NSString *host = hostArr[0];
        self.host = host;
        int port = [hostArr[1] intValue];
        self.port = port;
        NSLog(@"%@---%d",host,port);
        
        // 创建一个Socket对象
//        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        
        // 连接
        NSError *error = nil;
        [_socket connectToHost:host onPort:port error:&error];
        
        [self.messages addObject:@"socketConnectToHost"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error-----%@",error);
    }];

    
//    NSLog(@"========%@",[MPUserDefaults objectForKey:MPSessionId]);
}

/**
 *  网络环境变化判断
 */
- (void)networkReachability{
    
    NSLog(@"%@",[MPUserDefaults objectForKey:MPSessionId]);
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
     AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
     AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
     AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
     };
     */
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                //                self.navigationItem.title = @"未识别的网络";
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                //                self.navigationItem.title = @"网络不可用";
                [self.socket disconnect];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                [self connectToHost];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                [self connectToHost];
                break;
            default:
                break;
        }
    }];
//    开始监听
    [manager startMonitoring];
}

#pragma mark - 断开连接
-(void)disconnectHost
{
    [self.socket disconnect];
}

#pragma mark - 绑定
-(void)bindWithUserId:(NSString *)userId
{
    NSLog(@"绑定>>>");
    [self.socket writeData:[MessageDataPacketTool bindDataWithUserId:userId andIsUnbindFlag:NO] withTimeout:-1 tag:222];
    NSLog(@"%@",[MPUserDefaults objectForKey:MPSessionId]);
}

#pragma mark - 发送消息
-(void)sendMessageWithParameters:(NSDictionary *)parameters andURL:(NSString *)url
{
    
     [self.socket writeData:[MessageDataPacketTool chatDataWithBody:parameters andUrlStr:url] withTimeout:6 tag:222];
    
}

#pragma mark -GCDAsyncSocketDelegate
// 连接主机成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接主机成功");
    
    [self.messages addObject:@"socketDidConnectToHost"];
    
    if (![MessageDataPacketTool isFastConnect]) {
        [self.messages addObject:@"发送握手数据"];
        
        [sock writeData:[MessageDataPacketTool handshakeMessagePacketData] withTimeout:-1 tag:222];
        return;
    }
    
    [self.messages addObject:@"发送快速重连数据"];
    
    [sock writeData:[MessageDataPacketTool fastConnect] withTimeout:-1 tag:222];
    
}


// 与主机断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    [self clearHeartBeatTimer];
    if(err){
        NSLog(@"断开连接 %@",err);

        _connectNum ++;
        if (_connectNum < MPMaxConnectTimes) {
            sleep(_connectNum+2);
            NSError *error = nil;
            [_socket connectToHost:self.host onPort:self.port error:&error];
        }
    } else{
        NSLog(@"断开连接");
    }
    [self.messages addObject:@"socketDidDisconnect"];
    
}


// 数据成功发送到服务器
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"数据成功发送到服务器");
    //数据发送成功后，自己调用一下读取数据的方法，接着_socket才会调用下面的代理方法
    [_socket readDataWithTimeout:-1 tag:tag];
}

// 读取到数据时调用
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    
    //心跳
    if (data.length == 1) {
        
//        NSLog(@"读到数据了>>>>%@",data);
    
        return ;
    }
    
    // 半包处理
    int length = 0;
    if (_recieveNum < 1) {
        
        NSData *lengthData = [data subdataWithRange:NSMakeRange(0, 4)];
        [lengthData getBytes: &length length: sizeof(length)];
        NTOHL(length);
    }
    
    if (length > data.length - 13) {
        _recieveNum ++ ;
        [self.messageBodyData appendData:data];
        length = 0;
        return;
    }
    
    if (self.messageBodyData) {
       [self.messageBodyData appendData:data];
    }
    
    
    length = 0;
    _recieveNum = 0;
    
    IP_PACKET packet ;
    if (self.messageBodyData == nil) {
        //读取到的数据
        packet = [MessageDataPacketTool handShakeSuccessResponesWithData:data];
    } else {
        packet = [MessageDataPacketTool handShakeSuccessResponesWithData:self.messageBodyData];
    }
    self.messageBodyData = nil;
//    解密以前的body
    NSData *body_data = [NSData dataWithBytes:packet.body length:packet.length];
    
//    NSLog(@"状态码>>>%hhd",packet.cmd);
    switch (packet.cmd) {
            
        case MpushMessageBodyCMDHandShakeSuccess:
            NSLog(@"握手成功");
            
            [self.messages addObject:@"握手成功"];
            
            [self processHandShakeDataWithPacket:packet andData:body_data];
            break;
            
        case MpushMessageBodyCMDLogin: //登录
            
            break;
            
        case MpushMessageBodyCMDLogout: //退出
            
            break;
        case MpushMessageBodyCMDBind: //绑定
            
            break;
        case MpushMessageBodyCMDUnbind: //解绑
            
            break;
        case MpushMessageBodyCMDFastConnect: //快速重连
            
            NSLog(@"MpushMessageBodyCMDUNFastConnect");
            [self.messages addObject:@"快速重连成功"];
            
            [self addHeartBeatTimer:[MPUserDefaults doubleForKey:MPHeartbeatData]];
            break;
            
        case MpushMessageBodyCMDStop: //暂停
            break;
            
        case MpushMessageBodyCMDResume: //重新开始
            break;
            
        case MpushMessageBodyCMDError: //错误
            [MessageDataPacketTool errorWithBody:body_data];
            break;
            
        case MpushMessageBodyCMDOk: //ok
            //            [MessageDataPacketTool okWithBody:body_data];
            [self.messages addObject:@"操作成功!"];
            
            break;
            
        case MpushMessageBodyCMDHttp: // http代理
        {
            NSLog(@"ok======聊天=========");
            [self.messages addObject:@"成功调用http代理"];
            
            NSData *bodyData = [MessageDataPacketTool processFlagWithPacket:packet andBodyData:body_data];
            NSDictionary *responesBody = [MessageDataPacketTool chatDataSuccessWithData:bodyData];
            
//            回调消息体
            if (self.resultBlock) {
                self.resultBlock(responesBody);
            }
            
        }
            break;
        case MpushMessageBodyCMDPush:  //收到的push消息
            [self processRecievePushMessageWithPacket:packet andData:body_data];
            
            break;
            
        case MpushMessageBodyCMDChat: //聊天
            break;
            
        default:
            break;
    }
    
    [sock readDataWithTimeout:-1 tag:tag];//持续接收服务端放回的数据
}
/**
 *  心跳
 */
- (void)heartbeatSend{
    
    [self.messages addObject:@"发送心跳"];
    
    NSLog(@">>>>>发送心跳");
    
    [_socket writeData:[MessageDataPacketTool heartbeatPacketData] withTimeout:-1 tag:123];
}

/**
 *  处理收到的消息
 *
 *  @param packet    协议包
 *  @param body_data 协议包body data
 */
- (void)processRecievePushMessageWithPacket:(IP_PACKET)packet andData:(NSData *)body_data{
    
    
    id content = [MessageDataPacketTool processRecievePushMessageWithPacket:packet andData:body_data];
    NSString *contentJsonStr = content[@"content"];
    NSDictionary *contentDict = [self dictionaryWithJsonString:contentJsonStr];
    NSString *contentStr = contentDict[@"content"];
    
    [self.messages addObject:[NSString stringWithFormat:@"收到push消息--%@",contentStr]];
    
//    NSLog(@"content--%@",contentDict);
    
    NSString *pushResult = [NSString stringWithFormat:@"%@",contentDict[@"content"]];
    
    NSLog(@"收到推送>>>%@",pushResult);
    
    
    if (self.notiBlock) {
        self.notiBlock(contentDict);
    }
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        localNotification.alertBody = pushResult;
        localNotification.repeatInterval = 0;
        localNotification.alertTitle = @"乐途科技";
        localNotification.userInfo = contentDict;
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = 1;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        NSLog(@"此处弹出通知...");
        
    });
     */

    
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *  处理心跳响应的数据
 *
 *  @param bodyData 握手ok的bodyData
 */
- (void) processHeartDataWithData:(NSData *)bodyData{
    NSLog(@"接收到心跳");
}

/**
 *  处理握手ok响应的数据
 *
 *  @param body_data 握手ok的bodyData
 */
- (void) processHandShakeDataWithPacket:(IP_PACKET)packet andData:(NSData *)body_data{
    NSLog(@"当前线程>>>currentThread--%@",[NSThread currentThread]);
    [MessageDataPacketTool HandSuccessBodyDataWithData:body_data andPacket:packet];
    [self addHeartBeatTimer:[MPUserDefaults doubleForKey:MPHeartbeatData]];
}

/// 增加心跳定时器
- (void)addHeartBeatTimer:(NSTimeInterval)time{
    
    NSLog(@"增加心跳定时器>>>MPHeartbeatData--%.2f",[MPUserDefaults doubleForKey:MPHeartbeatData]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(heartbeatSend) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    });
    
}

/// 清除心跳定时器
- (void)clearHeartBeatTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timer invalidate];
        _timer = nil;
    });
}



@end
