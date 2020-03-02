//
//  UniversalMacro.h
//  ZhiFu
//
//  Created by betterda-zyqi on 2017/12/26.
//  Copyright © 2017年 OSX. All rights reserved.
//

#ifndef UniversalMacro_h
#define UniversalMacro_h


#endif /* UniversalMacro_h */

#pragma mark - 判空
// ========判空============
// 字符串
#define kIsEmptyStr(str)  ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"] ? YES : NO )
// 判断空并且替换
#define kIsEmptyStrReplac(str1,str2)  ([str1 isKindOfClass:[NSNull class]] || str1 == nil || [str1 length] < 1 || [str1 isEqualToString:@"<null>"] || [str1 isEqualToString:@"(null)"]? str2 : str1)

// 数组
#define kIsEmptyArr(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
// 字典
#define kIsEmptyDic(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 || dic.count == 0)
// 对象
#define kIsEmptyObj(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#pragma mark - 数据

#define kIntValue(str) [kIsEmptyStrReplac(str,@"0")  intValue]
#define kFloatValue(str) [kIsEmptyStrReplac(str,@"0.0") floatValue]
#define kString(str)  [NSString stringWithFormat:@"%@",str]
#define kStrNum(num)  [NSString stringWithFormat:@"%@",@(num)]
#define kStrUrl(str) [NSString stringWithFormat:@"http://%@",str]
#define kStrMerge(str1,str2)  [NSString stringWithFormat:@"%@%@",str1,str2]
#define kStrEqual(str1,str2) [str1 isEqualToString:str2]
#define kUrl(str1)  [NSURL URLWithString:str1]

#pragma mark -------------------- 判断 --------------------
// 是否iPhone X
#define IS_IPHONEX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
// 是否iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//是否iPad
#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#pragma mark -------------------- 判空 --------------------
// 字符串
#define IsEmptyStr(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1) || (NSNull *)str == [NSNull null] || [str isEqualToString:@"<null>"] || [str isEqualToString:@"null"] || [str isEqualToString:@"(null)"]
// 数组
#define IsEmptyArr(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
// 字典
#define IsEmptyDic(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
// 对象
#define IsEmptyObj(object) (object == nil \
|| [object isKindOfClass:[NSNull class]] \
|| ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) \
|| ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0))
//取值判断
#define HandleStr(x) (IsEmptyStr(x) ? @"":(x))
#define HandleArr(x) (IsEmptyArr(x) ? nil:(x))
#define HandleDic(x) (IsEmptyDic(x) ? nil:(x))
#define HandleObj(x) (IsEmptyObj(x) ? nil:(x))
#define HandleNumber(x) (IsEmptyStr(x) ? @"0":(x))

#pragma mark -------------------- 尺寸 --------------------
// 界面宽高
#define ScreenSize [UIScreen mainScreen].bounds.size
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define Scale [[UIScreen mainScreen] bounds].size.width/375

// 界面宽高比例
#define SH (IS_IPHONEX ? ScreenHeight / 812 : ScreenHeight / 667)
#define SW ScreenWidth / 375
// 状态栏高度
#define StatusBar_Height [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航栏高
#define kNav_H (kScreen_H == 812.0 ? 88:64)
// 状态栏 ＋ 导航栏 高度
#define Status_And_Navigation_Height ((StatusBar_Height) + (NavigationBar_Height))
// 底部tab高度
#define TabBar_Height (IS_IPHONEX ? 83 : 49)
//设置字体大小
#define Font(size) [[[UIDevice alloc]deviceModel] containsString:@"Plus"] | IS_IPHONEX ? [UIFont systemFontOfSize:size + 2] : [UIFont systemFontOfSize:size]
#define BoldFont(size) [[[UIDevice alloc]deviceModel] containsString:@"Plus"] | IS_IPHONEX ? [UIFont systemFontOfSize:size + 2] : [UIFont boldSystemFontOfSize:size]

#pragma mark -------------------- 缩写 --------------------
// frame
#define kFrame(x,y,w,h)         CGRectMake((x), (y), (w), (h))
// UIEdgeInsets
#define kEdgeInsets(top,left,bottom,right) UIEdgeInsetsMake((top),(left),(left),(right))

// 屏幕宽
#define kScreen_W [UIScreen mainScreen].bounds.size.width
// 屏幕高
#define kScreen_H [UIScreen mainScreen].bounds.size.height

// UI设计稿的 宽 高
#define kUI_W 375.0
#define kUI_H 667.0

// 适配比例 iPhone6 为标准  等比例缩放宽高位置 4（320*480） 5（320*568）6（375*667）6+（414*736）
#define kScale_W(w) ((w)*kScreen_W/kUI_W)
#define kScale_H(h) ((h)*kScreen_H/kUI_H)

// 获取Window
#define kWindow [UIApplication sharedApplication].keyWindow
// Application
#define kApplication        [UIApplication sharedApplication]
// AppDelegate对象
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
// UserDefaults
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
// NotificationCenter
#define kNotificationCenter [NSNotificationCenter defaultCenter]
//获取图片【本色】
#define kOriginalImage(imgStr) [[UIImage imageNamed:imgStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//获取url链接
#define kURLStr(urlStr) [NSURL URLWithString:urlStr]
// 打开网络地址
#define kOpenUrl(url) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#define kUrl(url) [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[url hasPrefix:@"http"] ? url : [NSString stringWithFormat:@"%@%@",IP,url]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
#define kImageUrl(url) [NSURL URLWithString:[NSString stringWithFormat:@"%@",[url hasPrefix:@"http"] ? url : [NSString stringWithFormat:@"%@%@",IP,url]]]
#define IP_SPLICE(url) [NSString stringWithFormat:@"%@%@",IP,url]

#define IP_SPLICECAR(url) [NSString stringWithFormat:@"%@%@",CARIP,url]
//替换字符串
#define kReplace_Str(originalStr, replaceStr) [originalStr stringByReplacingOccurrencesOfString:@"%@" withString:replaceStr]

#pragma mark -------------------- 系统消息 --------------------
// App版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 系统版本
#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
// 获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
// 获取temp
#define kPathTemp NSTemporaryDirectory()
// 获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define kPathLibrary [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
//语言国际化
#define Localized(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"InfoPlist"] ? [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"InfoPlist"] : key

//弱引用
//#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//打印输出
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define YQLog(str, ...) NSLog((@"\n%s [Line %d]\n " str @"\n"), __PRETTY_FUNCTION__,__LINE__, ##__VA_ARGS__);
#else
#define NSLog(...) while(0)
#define YQLog(str, ...) while(0)
#endif

//𝜋
#define PI 3.14159265358979323846
