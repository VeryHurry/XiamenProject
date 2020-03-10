//
//  RequestIP.m
//  BaNaMa_APP
//
//  Created by betterda-zyqi on 2018/10/16.
//  Copyright © 2018年 betterda-zyqi. All rights reserved.
//

#import "RequestIP.h"

//#ifdef DEBUG

//NSString *const IP = @"http://192.168.1.117:8084";
//NSString *const CARIP = @"http://192.168.1.117:8080";
NSString *const IP = @"http://59.56.111.74:18084";
NSString *const CARIP = @"http://59.56.111.74:18080";

//NSString *const IP = @"http://192.168.1.43:8084";
//NSString *const CARIP = @"http://192.168.1.43:8080";

//#else
//
//NSString *const IP = @"http://192.168.1.100:8080/gps";
//NSString *const CARIP = @"http://59.56.111.74:18080";

//#endif

NSString *const IP_CheckVersion = @"/xm/upgrade/isUpgrade";//检测是否有新版本
NSString *const IP_GetVersion = @"/xm/upgrade/upgrade";//获取新版本
NSString *const IP_LOGIN = @"/xm/loginApp";//账号登陆
NSString *const IP_Home_Message = @"/xm/notice/indexPage";//首页信息
NSString *const IP_GetNoticeInfo = @"/xm/notice/getNoticeInfo";//公告详情
NSString *const IP_GETSMS = @"/xm/sms/sendSms";//验证码
NSString *const IP_PASSWORD_FORGET = @"/xm/forgetPassword";//忘记密码
NSString *const IP_PASSWORD_REPLACE = @"/xm/editPassword";//修改密码
NSString *const IP_REGIST = @"/xm/addUserApp";//新增用户
NSString *const IP_ExaminationList = @"/xm/examine/userExaminationList";//试卷列表
NSString *const IP_GetExamination = @"/xm/examine/getExamination";//试卷详情
NSString *const IP_TestWeb = @"/tourist/training";//测试封面H5地址
NSString *const IP_SubmitTest = @"/xm/examine/examinationRecode";//提交测试
NSString *const IP_BindVehicle = @"/xm/electriccar/bandingElectriccarApp";//绑定车辆
NSString *const IP_LawList = @"/xm/breakTheLaw/lawListApp";//违法记录查询
NSString *const IP_LawTypeList = @"/xm/law/list";//违法类型列表
NSString *const IP_Post_LawList = @"/tocs-member-app/letu/gps/addLaw";//提交违法记录
NSString *const IP_MyLawList = @"/xm/breakTheLaw/convenientlyPhotoApp";//我的随手拍
NSString *const IP_VehicleInformation = @"/xm/electriccar/bandingAppStep1";//车辆信息
NSString *const IP_CarCurrentInfo = @"/xm/electriccar/carCurrentInfo";//车辆当前运行状态
NSString *const IP_UnBindVehicle = @"/xm/electriccar/unBandingElectriccarApp";//解绑车辆
NSString *const IP_VehicleMessage = @"/xm/electriccar/electriccarInfo";//车辆详细信息
NSString *const IP_UserInfo = @"/xm/userInfo";//骑手信息
NSString *const IP_UserVehicle = @"/xm/userVehicle";//骑手车辆信息
NSString *const IP_MyTrack = @"/xm/myTrack";//我的行程
NSString *const IP_TrackInfo = @"/xm/trackInfo";//轨迹数据接口

NSString *const IP_BindStatus = @"/xm/userVehicle";//绑定状态
NSString *const IP_VehicleInfo = @"/tocs-member-app/letu/gps/vehicle/indexInfo";//当前页面
NSString *const IP_UploadHead = @"/tocs-member-app/letu/gps/addHeadImg";//上传头像

NSString *const IP_Clockin = @"/xm/clockin/isClockIn";//是否打卡接口
NSString *const IP_GetFiveSubject = @"/xm/clockin/getFiveSubject";//获取5条随机试题接口
NSString *const IP_AddClockin = @"/xm/clockin/add";//提交打卡试题接口


@implementation RequestIP

@end
