//
//Created by ESJsonFormatForMac on 19/07/03.
//

#import <Foundation/Foundation.h>

@class trackModel;
@interface MyTrackModel : NSObject

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger total;

@end
@interface trackModel : NSObject

@property (nonatomic, copy) NSString *imeiNo;

@property (nonatomic, copy) NSString *totalFront;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *vehicleNo;

@property (nonatomic, copy) NSString *between;

@property (nonatomic, copy) NSString *endAdress;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, assign) NSInteger mileage;

@property (nonatomic, copy) NSString *trackNo;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *startAdress;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *sql;

@property (nonatomic, assign) NSInteger parentId;

@property (nonatomic, copy) NSString *condition;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, copy) NSString *orderBy;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *like;

@property (nonatomic, copy) NSString *beginTime;

@end

