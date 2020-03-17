//
//Created by ESJsonFormatForMac on 20/03/13.
//

#import <Foundation/Foundation.h>

@class CompanyModel;
@interface CompanyListModel : NSObject

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger total;

@end
@interface CompanyModel : NSObject

@property (nonatomic, copy) NSString *parentIds;

@property (nonatomic, copy) NSString *beginTime;

@property (nonatomic, assign) NSString *ID;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *telNo;

@property (nonatomic, assign) NSInteger accountId;

@property (nonatomic, copy) NSString *businessLicense;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger isAdmin;

@property (nonatomic, copy) NSString *legalPerson;

@property (nonatomic, assign) NSInteger isSameLevel;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *parentName;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *totalFront;

@property (nonatomic, copy) NSString *condition;

@property (nonatomic, copy) NSString *like;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *orderBy;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *hasChild;

@property (nonatomic, assign) NSInteger numberOfPeople;

@property (nonatomic, assign) NSInteger numberOfVehicle;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, copy) NSString *companyNo;

@property (nonatomic, copy) NSString *between;

@property (nonatomic, copy) NSString *companyType;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *workTimeEnd;

@property (nonatomic, assign) NSInteger sameLevel;

@property (nonatomic, copy) NSString *sql;

@property (nonatomic, copy) NSString *workTimeStart;

@property (nonatomic, assign) NSInteger parentId;

@property (nonatomic, copy) NSString *identity;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *message;

@end

