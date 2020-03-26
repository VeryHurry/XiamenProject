//
//Created by ESJsonFormatForMac on 19/06/26.
//

#import <Foundation/Foundation.h>
#import "QKCoding.h"


@interface UserModel : QKCoding

@property (nonatomic, copy) NSString *parentIds;

@property (nonatomic, copy) NSString *emergencyContact;

@property (nonatomic, copy) NSString *beginTime;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *insuranceFile;

@property (nonatomic, copy) NSString *telNo;

@property (nonatomic, copy) NSString *emergencyContactPhone;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, assign) NSInteger isAdmin;

@property (nonatomic, assign) NSInteger isSameLevel;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *vehicleNo;

@property (nonatomic, copy) NSString *parentName;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *totalFront;

@property (nonatomic, copy) NSString *condition;

@property (nonatomic, copy) NSString *identityCard;

@property (nonatomic, copy) NSString *insuranceNo;

@property (nonatomic, copy) NSString *like;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *staffNo;

@property (nonatomic, assign) NSInteger examineNumber;

@property (nonatomic, copy) NSString *orderBy;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *hasChild;

@property (nonatomic, copy) NSString *numberOfPeople;

@property (nonatomic, copy) NSString *numberOfVehicle;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, copy) NSString *cmccMobile;

@property (nonatomic, copy) NSString *between;

@property (nonatomic, copy) NSString *physicalInfo;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger sameLevel;

@property (nonatomic, copy) NSString *sql;

@property (nonatomic, assign) NSInteger isBanding;

@property (nonatomic, assign) NSInteger parentId;

@property (nonatomic, copy) NSString *identity;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *message;

@end
