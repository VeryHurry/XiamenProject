//
//  RequestIP.h
//  BaNaMa_APP
//
//  Created by betterda-zyqi on 2018/10/16.
//  Copyright © 2018年 betterda-zyqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestIP : NSObject

//#ifdef DEBUG
extern NSString *const IP;//IP
extern NSString *const CARIP;
//#else
//extern NSString *const IP;//IP
//extern NSString *const CARIP;
//#endif


extern NSString *const IP_CheckVersion;
extern NSString *const IP_GetVersion;
extern NSString *const IP_LOGIN;//账号登陆
extern NSString *const IP_Home_Message;//首页信息
extern NSString *const IP_GetNoticeInfo;
extern NSString *const IP_GETSMS;
extern NSString *const IP_PASSWORD_FORGET;
extern NSString *const IP_PASSWORD_REPLACE;
extern NSString *const IP_REGIST;
extern NSString *const IP_ExaminationList;
extern NSString *const IP_GetExamination;
extern NSString *const IP_TestWeb;
extern NSString *const IP_SubmitTest;
extern NSString *const IP_BindVehicle;
extern NSString *const IP_LawList;
extern NSString *const IP_LawTypeList;
extern NSString *const IP_Post_LawList;
extern NSString *const IP_MyLawList;
extern NSString *const IP_VehicleInformation;
extern NSString *const IP_CarCurrentInfo;
extern NSString *const IP_UnBindVehicle;
extern NSString *const IP_VehicleMessage;
extern NSString *const IP_UserInfo;
extern NSString *const IP_UploadHead;
extern NSString *const IP_UserVehicle;
extern NSString *const IP_MyTrack;
extern NSString *const IP_TrackInfo;

extern NSString *const IP_BindStatus;
extern NSString *const IP_VehicleInfo;



@end
