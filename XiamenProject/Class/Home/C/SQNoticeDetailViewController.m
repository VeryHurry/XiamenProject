//
//  SQNoticeDetailViewController.m
//  XiamenProject
//
//  Created by mac on 2019/7/9.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQNoticeDetailViewController.h"
#import "MacroDefinition.h"

@interface SQNoticeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation SQNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBack = YES;
    self.title = @"公告详情";
    self.view.backgroundColor = kWhite;
    [self getMessage];
}

#pragma mark - Network

- (void)getMessage
{
    if ([Base_AFN_Manager isNetworking]) {
        
        [Base_AFN_Manager postUrl:IP_SPLICE(IP_GetNoticeInfo) parameters:@{@"id":self.cid} success:^(id success) {
            if (!kIsEmptyObj(success)) {
                self.titleLbl.text = success[@"notice"][@"title"];
                self.content.text = [NSString stringWithFormat:@"      %@",success[@"notice"][@"content"]];
            }
            
        } failure_login:nil failure_data:^(id failure) {
            
        } error:^(id error) {
            
        }];
    } else {
        
    }
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
