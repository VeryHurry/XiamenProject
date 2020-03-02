//
//  SocketManager.h
//  LeTu
//
//  Created by mtt on 2017/10/18.
//  Copyright © 2017年 mtt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "MessageDataPacketTool.h"
#import "Mpush.h"
#import "MacroDefinition.h"


@interface SocketManager : NSObject<GCDAsyncSocketDelegate>
/** 盛放消息内容的数组  */
@property(nonatomic,strong)NSMutableArray *messages;

@property(nonatomic,strong)GCDAsyncSocket *socket;
/**  发送心跳的计时器 */
@property(nonatomic,strong)NSTimer *timer;
/**  一条消息接收到的次数（半包处理） */
@property(nonatomic,assign)int recieveNum;
/**  接收到消息的body Data */
@property(nonatomic,strong)NSMutableData *messageBodyData;
/** 绑定的用户id  */
//@property(nonatomic,copy)NSString *userId;
/** 连接次数  */
@property(nonatomic,assign)int connectNum;
/** host  */
@property(nonatomic,copy)NSString *host;
/** port  */
@property(nonatomic,assign)int port;

//回调得到的消息体
@property (nonatomic,copy)void (^resultBlock)(NSDictionary *dataBody);

//回调通知内容
@property (nonatomic,copy)void (^notiBlock)(NSDictionary *contentDic);

//初始化
+(instancetype)instance;

//监测网络环境
-(void)networkReachability;
//连接到主机
- (void)connectToHost;

//发送消息
-(void)sendMessageWithParameters:(NSDictionary *)parameters andURL:(NSString *)url;

//绑定
-(void)bindWithUserId:(NSString *)userId;

//断开连接
-(void)disconnectHost;

//添加心跳定时器
-(void)addLocationHeartBeat;

-(void)sendLocationHeartBeat;








@end
