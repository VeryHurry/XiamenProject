//
//  UserDefaultsTool.h
//  ZhiFu
//
//  Created by OSX on 17/6/19.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UserDefaultsTool : NSObject

//nsuserdefaults设置、获取
+ (void)setObj:(id)value forKey:(id)key;
+ (void)setBool:(BOOL)value forKey:(id)key;
+ (void)setInt:(NSInteger)value forKey:(id)key;
+ (id)getObjForKey:(id)key;
+ (NSString *)getStringForKey:(id)key;
+ (NSArray *)getArrayForKey:(id)key;
+ (BOOL)getBoolForKey:(id)key;
+ (NSInteger)getIntForKey:(id)key;


//判断文件是否已经在沙盒Cache中已经存在？
+ (BOOL)isCacheFileExist:(NSString *)fileName;
//判断文件是否已经在沙盒Document中已经存在？
+ (BOOL)isDocumentFileExist:(NSString *)fileName;
//判断文件是否已经在沙盒Preference中已经存在？
+ (BOOL)isPreferenceFileExist:(NSString *)fileName;

//删除沙盒Cache中的文件
+ (BOOL)deleteCacheFile:(NSString *)fileName;
//删除沙盒Document中的文件
+ (BOOL)deleteDocumentFile:(NSString *)fileName;
//删除沙盒Preference中的文件
+ (BOOL)deletePreferenceFile:(NSString *)fileName;
@end
