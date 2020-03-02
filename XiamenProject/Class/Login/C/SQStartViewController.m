//
//  SQStartViewController.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/24.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQStartViewController.h"
#import "SQTabbarViewController.h"
#import "SQGuideViewController.h"
#import "MacroDefinition.h"
#define K_Screen_width [UIScreen mainScreen].bounds.size.width
#define K_Screen_height [UIScreen mainScreen].bounds.size.height
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
#define KScale [[UIScreen mainScreen] bounds].size.width/375
@interface SQStartViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *imageScrollView;
@property (strong, nonatomic ) NSTimer *timer; //计时器

@end

@implementation SQStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageArray = @[@"startpage_image1",@"startpage_image2",@"startpage_image3"];
    [self createScrollView];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopTimer];
}


- (void)createScrollView
{
    
    CGFloat height = K_Screen_width*1166/750;
    CGFloat imgSpace;
    _imageScrollView = [[UIScrollView alloc]init];
    if (IPHONE_X) {
         _imageScrollView.frame = CGRectMake(0, kNav_H, K_Screen_width, height);
        imgSpace = 30 *KScale;
    }
    else
    {
        _imageScrollView.frame = CGRectMake(0, 0, K_Screen_width, height);
        imgSpace = 16 *KScale;
    }
    
    _imageScrollView.contentSize = CGSizeMake(K_Screen_width *self.imageArray.count, height);
    _imageScrollView.delegate = self;
    _imageScrollView.bounces = YES;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_imageScrollView];
    for (int i = 0; i < self.imageArray.count; i++) {
        NSString *imageName = self.imageArray[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor purpleColor];
        imageView.frame = CGRectMake(K_Screen_width * i, 0, K_Screen_width, _imageScrollView.frame.size.height);
        [_imageScrollView addSubview:imageView];
        
        imageView.image = [UIImage imageNamed:imageName];
    }
    
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:kFrame((kScreen_W-49*KScale)/2, _imageScrollView.xx_max_y + imgSpace, 49*KScale, 37*KScale)];
    img.image = [UIImage imageNamed:@"logo_ic"];
    [self.view addSubview:img];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:kFrame(0, img.xx_max_y +10*KScale, kScreen_W, 15*KScale)];
    lbl.text = @"厦门市电动自行车公共监管平台";
    lbl.textColor = [UIColor colorWithHexStr:@"#3E3A39"];
    lbl.font = Font(KScale*13);
    lbl.textAlignment = 1;
    [self.view addSubview:lbl];
}


- (void)nextPage
{
    
    
    NSLog(@"-----------%lu",(unsigned long)self.imageScrollView.contentOffset.x);
         // 下一个页面，对总数取余的页码，循环滚动
    NSInteger page =  self.imageScrollView.contentOffset.x/K_Screen_width+1;
         // 计算偏移量，索引值和scrollView宽度的积
  
    if (page < self.imageScrollView.subviews.count) {
        CGFloat xxx = page *K_Screen_width;
        NSLog(@"-----------%f",xxx);
        CGPoint offset = CGPointMake(xxx, 0);
        // 设置新的偏移量
        [self.imageScrollView setContentOffset:offset animated:YES];

    }
    else
    {
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"isFirst"]) {
            SQGuideViewController *vc = [[SQGuideViewController alloc]init];
            [vc showGuideViewWithImageArray:@[@"guide_image1",@"guide_image2",@"guide_image3",@"guide_image4"] WindowRootController:[SQTabbarViewController new]];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            
            
        }else{
            SQTabbarViewController * vc = [[SQTabbarViewController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        }
    }
    
   
}

#pragma mark - 定时器
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 {
         // 没有拖动图片就开始定时器
         [self startTimer];
     }

 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
 {
         // 一旦开始拖动就停止计时器
         [self stopTimer];
 }

- (void)startTimer
{
        //  创建定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
         // 设置计时器线程的优先级和其他线程一样
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}


- (void)stopTimer
{
        [self.timer invalidate]; // 停止计时器
        self.timer = nil; //清空指针
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
