//
//  DataModel.h
//  MTTWallet
//
//  Created by mtt on 2017/3/17.
//  Copyright © 2017年 mtt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefinition.h"

@interface DataModel : NSObject

+(void)getDataWithURL:(NSString *)url parameters:(NSDictionary *)parameters returnBlock:(void(^)(NSDictionary * dic))dataBlock;

+(void)getBasedDataWithURL:(NSString *)url parameters:(NSDictionary *)parameters returnBlock:(void(^)(NSDictionary *dic))dataBlock;

@end
