//
//  SQViolationsDetailViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/22.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQViolationsDetailViewController.h"
#import "MacroDefinition.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"

@interface SQViolationsDetailViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *disposeTime;

@end

@implementation SQViolationsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.title = @"违法详情";
    _orderNo.text = _model.orderNo;
    
    NSMutableArray *temp = [NSMutableArray new];
    if (!kIsEmptyStr(_model.file1)) {
        [temp addObject:_model.file1];
    }
    if (!kIsEmptyStr(_model.file2)) {
        [temp addObject:_model.file2];
    }
    if (!kIsEmptyStr(_model.file3)) {
        [temp addObject:_model.file3];
    }
    if (temp.count >1) {
        _img.userInteractionEnabled = YES;
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _img.xx_width, _img.xx_height) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView2.autoScroll = NO;
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        cycleScrollView2.imageURLStringsGroup = temp;
        [_img addSubview:cycleScrollView2];
    }
    else
    {
        [_img sd_setImageWithURL:[NSURL URLWithString:_model.file1]];
        _img.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    _type.text = _model.law;
    
    _state.text = _model.status == 2||_model.status == 3 ? @"已处理":@"未处理";
    _state.textColor = _model.status == 0||_model.status == 1 ? kBlue : kGreen;
    _time.text = kIsEmptyStr(_model.createTime) ? @"-":_model.createTime;
    
    _address.text = _model.lawAddress;
    _content.text = _model.law;
    
    _remark.text = kIsEmptyStr(_model.remark) ? @"-":_model.remark;
    _disposeTime.text = kIsEmptyStr(_model.disposeTime) ? @"-":_model.disposeTime;
    
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
