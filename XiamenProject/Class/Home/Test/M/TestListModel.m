//
//Created by ESJsonFormatForMac on 19/05/14.
//

#import "TestListModel.h"
@implementation TestListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"subjectList" : [Subjectlist class]};
}



@end

@implementation Result

@end


@implementation Subjectlist

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end


