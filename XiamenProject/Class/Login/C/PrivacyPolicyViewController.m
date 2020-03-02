//
//  PrivacyPolicyViewController.m
//  XiamenProject
//
//  Created by mac on 2020/1/14.
//  Copyright © 2020 MacStudent. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "MacroDefinition.h"

@interface PrivacyPolicyViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *mainView;

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"隐私协议";
    self.isBack = YES;
    self.view.backgroundColor = kWhite;
    _mainView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H)];
    _mainView.delegate = self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://shimo.im/docs/jgGQJxJPc8PCWY9T"]];
    [self.mainView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_mainView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request.URL absoluteString];
    //拦截链接跳转
    if ([url rangeOfString:@"https://shimo.im/docs/jgGQJxJPc8PCWY9T"].location != NSNotFound){
        
        return YES;
    }
    return NO;
}

@end
