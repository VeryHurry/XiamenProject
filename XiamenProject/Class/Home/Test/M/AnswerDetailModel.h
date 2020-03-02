//
//  AnswerDetailModel.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/15.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

@class optionsList;

@interface AnswerDetailModel : NSObject


@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSArray *optionsList;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, assign) NSInteger titleNo;

@end

@interface optionsList : NSObject

@property (nonatomic, assign) BOOL checked;

@property (nonatomic, copy) NSString *answerNo;
@property (nonatomic, copy) NSString *answer;

@end

