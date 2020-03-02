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

//NSString *const IP = @"http://192.168.1.137:8084";
//NSString *const CARIP = @"http://192.168.1.137:8080";

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



NSString *const IP_AUTH_STATUS = @"api/certification/authProgress";//认证状态查询
NSString *const IP_AUTH_SUBMIT_INFO = @"api/certification/submitInfo";//提交信息认证
NSString *const IP_AUTH_SUBMIT_CERT = @"api/certification/submitCert";//提交证件认证
NSString *const IP_ADDRESS_LIST = @"api/basic/getTerritoryTree";//获取所有地区
NSString *const IP_CACHE = @"api/basic/allTypeList";//获取所有字典列表
NSString *const IP_CACHE_SEARCH = @"api/basic/typeList";//获取字典列表
NSString *const IP_QUESTION_FIND = @"api/security/findQuestion";//获取密保问题和答案
NSString *const IP_QUESTION_USER = @"api/security/findUserQuestion";//获取用户密保问题
NSString *const IP_QUESTION_SET = @"api/security/setQuestion";//设置密保问题
NSString *const IP_PAY_SETUP = @"api/security/newPayPwd";//安全密码设置(密码需要至少8位包含特殊字符)
NSString *const IP_PAY_PASSWORD_CHANGE = @"api/security/modifyPayPwd";//安全密码修改(密码需要至少8位包含特殊字符)
NSString *const IP_PAY_PASSWORD_RESET = @"api/security/resPayPwd";//安全密码重置(密码需要至少8位包含特殊字符)
NSString *const IP_FEEDBACK = @"api/app/feedback";//发送反馈
NSString *const IP_PERSONAL_GET = @"api/account/getInfo";//获取个人基本信息
NSString *const IP_PERSONAL_SET = @"api/account/updateInfo";//修改个人基本信息

NSString *const IP_BANKCARD_CARDTYPELIAT = @"api/card/cardKindList";//获取卡种列表
NSString *const IP_BANKCARD_APPLY = @"api/card/bankCardApply";//卡片申请
NSString *const IP_BANKCARD_APPLY_QUERY = @"api/card/bankCardApplyQuery";//卡片申请进度查询
NSString *const IP_BANKCARD_LIST = @"api/card/normalcard";//卡片列表
NSString *const IP_BANKCARD_HOMEORDER = @"api/card/allBankCardTrade";//卡片总交易明细
//NSString *const IP_BANKCARD_MESSAGE = @"api/card/bankCardMsg";//卡片信息明细
NSString *const IP_BANKCARD_BIND = @"api/card/bankCardBind";//卡片绑定
NSString *const IP_BANKCARD_REPLACEPASSWORD = @"api/card/modifyPin";//修改卡密码
NSString *const IP_BANKCARD_BALANCE = @"api/card/cardBalance";//获取卡帐户余额
NSString *const IP_BANKCARD_UNBIND = @"api/card/bankCardUntie";//卡片解绑
NSString *const IP_BANKCARD_RESETPASSWORD = @"api/card/resetPin";//重置卡密码
NSString *const IP_BANCKCARD_ACTIVE = @"api/card/bankCardActive";//卡片激活
NSString *const IP_WALLET_BALANCE = @"api/wallet/get";//获取钱包余额
NSString *const IP_HISTORYMAN = @"api/payment/payees";//历史收款人
NSString *const IP_ORDER_LIST = @"api/tradeOrder/details/get";//账单明细
NSString *const IP_BANNER = @"api/app/banner";//轮播图
NSString *const IP_HOTQUESTION = @"api/app/issue";//热门问题
NSString *const IP_HOTISSUE = @"api/app/commonIssue";//热门问题
NSString *const IP_HOTISSUEDETAIL = @"api/app/common/";//热门问题详情
NSString *const IP_MESSAGELIST = @"api/message/getList";//获取消息列表
NSString *const IP_MESSAGE_DELETE = @"api/message/removeMsg";//删除消息
NSString *const IP_CURRENCY_LIST = @"api/card/foreignCName";//币种列表
NSString *const IP_RATE_CHANGE = @"api/card/rateChange";//汇率换算
NSString *const IP_BANKCARD_PAYMENTLIST = @"api/payment/account";//付款帐户列表
NSString *const IP_WALLET_RECHARGE = @"api/wallet/recharge";//储值
NSString *const IP_WALLET_WITHDRAW = @"api/wallet/draw";//提现
NSString *const IP_WALLET_WITHDRAW_FEE = @"api/wallet/drawFee/get";//提现费率
NSString *const IP_ACCOUNT_SEARCH = @"api/account/search";//用户搜索
NSString *const IP_TRANSFER_BANKCARD_RATE = @"api/payment/transferRate";//计算转账费率
NSString *const IP_TRANSFER = @"api/payment/transfer";//提交转账订单
NSString *const IP_BANKCARD_ORDER_LIST = @"api/card/bankCardTrade";//卡片交易明细
NSString *const IP_TRANSFER_ORDER_LIST = @"api/payment/recordList";//支付记录列表
NSString *const IP_APP_VERSION = @"api/app/version";//最新版本
NSString *const IP_CARD_RECHARGE = @"api/card/recharge";//卡片储值
NSString *const IP_CARD_RECHARGE_LIST = @"api/card/cardRecharge";//卡片储值记录
NSString *const IP_APPLYCARD_RATE = @"api/app/getUserRateCache";//卡申请费用
NSString *const IP_AUTH_PASSWORD = @"api/security/checkPayPwd";//安全密码验证接口
NSString *const IP_AUTH_GET_INFO = @"api/certification/certInfo";//获取身份认证提交信息
NSString *const IP_AUTH_CERTTYPES = @"api/certification/certTypes";//证件类型
NSString *const IP_BANKCARD_LOCK = @"api/card/cardLocak";//银行卡锁卡
NSString *const IP_HISTORY_DELETE = @"api/payment/delPayees";//历史转账人删除
@implementation RequestIP

@end
