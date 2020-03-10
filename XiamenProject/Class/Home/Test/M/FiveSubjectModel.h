//
//Created by ESJsonFormatForMac on 20/03/05.
//

#import <Foundation/Foundation.h>

@class SubjectModel;
@interface FiveSubjectModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, assign) NSInteger status;

@end
@interface SubjectModel : NSObject

@property (nonatomic, copy) NSString *totalFront;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *options;

@property (nonatomic, copy) NSString *between;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *sql;

@property (nonatomic, copy) NSString *titleUrl;

@property (nonatomic, copy) NSString *condition;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, copy) NSString *orderBy;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *like;

@property (nonatomic, copy) NSString *beginTime;

@end

