//
//  SelectedAssetCell.h
//  XiamenProject
//
//  Created by MacStudent on 2019/5/30.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XG_AssetModel;
NS_ASSUME_NONNULL_BEGIN

@interface SelectedAssetCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) XG_AssetModel *model;

@end

NS_ASSUME_NONNULL_END
