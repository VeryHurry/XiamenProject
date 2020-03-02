//
//  AnswerCollectionViewCell.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/14.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestListModel.h"
#import "BlockMacro.h"
#import "AnswerDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnswerCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) AnswerDetailModel *model;

- (void)selectAnswerBlock:(XXObjBlock)block;

@end

NS_ASSUME_NONNULL_END
