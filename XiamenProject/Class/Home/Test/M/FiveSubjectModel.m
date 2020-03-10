//
//Created by ESJsonFormatForMac on 20/03/05.
//

#import "FiveSubjectModel.h"
@implementation FiveSubjectModel

+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [SubjectModel class]};
}

@end

@implementation SubjectModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}


@end


