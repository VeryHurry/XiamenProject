//
//  SQTestModel.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/13.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SQTestModel : NSObject

@property (copy, nonatomic) NSString *examinationName;
@property (copy, nonatomic) NSString *examinationNo;
@property (copy, nonatomic) NSString *titleNo;
@property (copy, nonatomic) NSString *answerNo;
@property (copy, nonatomic) NSString *scoreNo;
@property (copy, nonatomic) NSString *createPerson;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *isFinish;
@property (copy, nonatomic) NSString *status;

@end

NS_ASSUME_NONNULL_END
