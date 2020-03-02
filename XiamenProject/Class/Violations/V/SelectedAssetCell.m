//
//  SelectedAssetCell.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/30.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SelectedAssetCell.h"
#import "XG_AssetModel.h"
#import "XG_AssetPickerManager.h"
#import "UIView+XGAdd.h"

@implementation SelectedAssetCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)setModel:(XG_AssetModel *)model{
    _model = model;
    if (_model.isPlaceholder) {
        self.imgView.image = [UIImage imageNamed:@"add"];
        self.playBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
    }else{
        self.deleteBtn.hidden = NO;
        [[XG_AssetPickerManager manager] getPhotoWithAsset:_model.asset photoWidth:self.frame.size.width completion:^(UIImage *photo, NSDictionary *info) {
            self.imgView.image = photo;
        }];
        if (_model.asset.mediaType == PHAssetMediaTypeVideo) {
            self.playBtn.hidden = NO;
        }else{
            self.playBtn.hidden = YES;
        }
    }
    
}



@end
