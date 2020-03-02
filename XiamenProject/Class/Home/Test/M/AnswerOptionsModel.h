//
//  AnswerModel.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/15.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnswerOptionsModel : NSObject

@property (nonatomic, assign) BOOL checked;

@property (nonatomic, copy) NSString *answerNo;
@property (nonatomic, copy) NSString *answer;


@end

NS_ASSUME_NONNULL_END
