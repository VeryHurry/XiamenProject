//
//Created by ESJsonFormatForMac on 20/03/13.
//

#import "CompanyListModel.h"
@implementation CompanyListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [CompanyModel class]};
}

@end

@implementation CompanyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


