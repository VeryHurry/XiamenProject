//
//  UserDefaultsTool.m
//  ZhiFu
//
//  Created by OSX on 17/6/19.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "UserDefaultsTool.h"
#define kUserDefaults       [NSUserDefaults standardUserDefaults]

@implementation UserDefaultsTool

+ (void)setObj:(id)value forKey:(id)key {
    [kUserDefaults setObject:value forKey:key];
    [kUserDefaults synchronize];
}

+ (void)setBool:(BOOL)value forKey:(id)key {
    [kUserDefaults setBool:value forKey:key];
    [kUserDefaults synchronize];
}

+ (void)setInt:(NSInteger)value forKey:(id)key {
    [kUserDefaults setInteger:value forKey:key];
    [kUserDefaults synchronize];
}

+ (id)getObjForKey:(id)key {
    return [kUserDefaults objectForKey:key];
}

+ (NSString *)getStringForKey:(id)key {
    return [kUserDefaults objectForKey:key];
}

+ (NSArray *)getArrayForKey:(id)key {
    return [kUserDefaults objectForKey:key];
}

+ (BOOL)getBoolForKey:(id)key {
    return [kUserDefaults boolForKey:key];
}

+ (NSInteger)getIntForKey:(id)key {
    return [kUserDefaults integerForKey:key];
}

+ (BOOL)isCacheFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

+ (BOOL)isDocumentFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

+ (BOOL)isPreferenceFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

+ (BOOL)deleteCacheFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *file = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    BOOL delete = [fileManager removeItemAtPath:file error:nil];
    return delete;
}

+ (BOOL)deleteDocumentFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *file = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    BOOL delete = [fileManager removeItemAtPath:file error:nil];
    return delete;
}


+ (BOOL)deletePreferenceFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory,NSUserDomainMask, YES);
    NSString *file = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    BOOL delete = [fileManager removeItemAtPath:file error:nil];
    return delete;
}


@end
