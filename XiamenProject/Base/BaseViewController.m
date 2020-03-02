//
//  Base_ViewController.m
//  BaseFrame
//
//  Created by betterda-zyqi on 2018/5/10.
//  Copyright © 2018年 BaseFrame. All rights reserved.
//

#import "BaseViewController.h"
#import "MacroDefinition.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) NSArray<UIBarButtonItem *> *leftItems;
@property (nonatomic, strong) NSArray<UIBarButtonItem *> *rightItems;

@property (nonatomic, assign) CGPoint tapPoint;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *payAccountNo;//付款账号
@end

@implementation BaseViewController

//1.声明一个空的静态的单例对象
static BaseViewController *_vc = nil;
+ (BaseViewController *)sharedSingleton {
    //2.声明一个静态的gcd的单次任务
    static dispatch_once_t oneToken;
    //3.执行gcd单次任务：对对象进行初始化
    dispatch_once(&oneToken, ^{
        _vc = [[self alloc]init];
    });
    
    return _vc;
}

#pragma mark -------------------- 属性set --------------------
- (void)setIsBack:(BOOL)isBack {
    _isBack = isBack;
    if (isBack) {
        self.navigationItem.hidesBackButton = NO;
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ic_return"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        leftItem.tintColor = kBtnGray;
        self.navigationItem.leftBarButtonItem = leftItem;
        self.backItem = leftItem;
    } else {
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    if (_isBack) {
        self.backItem.tintColor = _backColor;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjects:@[_titleFont,_titleColor] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjects:@[_titleFont,_titleColor] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]];
}

- (void)setLeftTitleArray:(NSArray<NSString *> *)leftTitleArray {
    _leftTitleArray = leftTitleArray;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < leftTitleArray.count; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:leftTitleArray[i] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
        item.tag = i;
        item.tintColor = [UIColor whiteColor];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [array addObject:item];
    }
    self.navigationItem.leftBarButtonItems = array;
    self.leftItems = array;
}

- (void)setLeftTitleColor:(UIColor *)leftTitleColor {
    _leftTitleColor = leftTitleColor;
    if (_leftTitleArray.count) {
        for (UIBarButtonItem *item in self.leftItems) {
            item.tintColor = _leftTitleColor;
        }
    }
}

- (void)setLeftTitleFont:(UIFont *)leftTitleFont {
    _leftTitleFont = leftTitleFont;
    if (_leftTitleArray.count) {
        for (UIBarButtonItem *item in self.leftItems) {
            [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_leftTitleFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
        }
    }
}

- (void)setRightTitleArray:(NSArray<NSString *> *)rightTitleArray {
    _rightTitleArray = rightTitleArray;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < rightTitleArray.count; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:rightTitleArray[i] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
        item.tag = i;
        item.tintColor = [UIColor whiteColor];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [array addObject:item];
    }
    self.navigationItem.rightBarButtonItems = array;
    self.rightItems = array;
}

- (void)setRightTitleColor:(UIColor *)rightTitleColor {
    _rightTitleColor = rightTitleColor;
    if (_rightTitleArray.count) {
        for (UIBarButtonItem *item in self.rightItems) {
            item.tintColor = _rightTitleColor;
        }
    }
}

- (void)setRightTitleFont:(UIFont *)rightTitleFont {
    _rightTitleFont = rightTitleFont;
    if (_rightTitleArray.count) {
        for (UIBarButtonItem *item in self.rightItems) {
            [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_rightTitleFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
        }
    }
}

- (void)setSystemLeftItem:(UIBarButtonSystemItem)systemLeftItem {
    _systemLeftItem = systemLeftItem;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:_systemLeftItem target:self action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setSystemLeftItemColor:(UIColor *)systemLeftItemColor {
    _systemLeftItemColor = systemLeftItemColor;
    if (_systemLeftItem) {
        self.navigationItem.leftBarButtonItem.tintColor = _systemLeftItemColor;
    }
}

- (void)setSystemRightItem:(UIBarButtonSystemItem)systemRightItem {
    _systemRightItem = systemRightItem;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:_systemRightItem target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setSystemRightItemColor:(UIColor *)systemRightItemColor {
    _systemRightItemColor = systemRightItemColor;
    if (_systemRightItem) {
        self.navigationItem.rightBarButtonItem.tintColor = _systemRightItemColor;
    }
}

- (void)setLeftImageArray:(NSArray<UIImage *> *)leftImageArray {
    _leftImageArray = leftImageArray;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < leftImageArray.count; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[leftImageArray[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
        item.tag = i;
        [array addObject:item];
    }
    self.navigationItem.leftBarButtonItems = array;
    self.leftItems = array;
}

- (void)setLeftImageColor:(UIColor *)leftImageColor {
    _leftImageColor = leftImageColor;
    if (_leftImageArray.count) {
        for (UIBarButtonItem *item in self.leftItems) {
            item.tintColor = _leftImageColor;
        }
    }
}

- (void)setRightImageArray:(NSArray<UIImage *> *)rightImageArray {
    _rightImageArray = rightImageArray;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < rightImageArray.count; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[rightImageArray[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
        item.tag = i;
        [array addObject:item];
    }
    self.navigationItem.rightBarButtonItems = array;
    self.rightItems = array;
}

- (void)setRightImageColor:(UIColor *)rightImageColor {
    _rightImageColor = rightImageColor;
    if (_rightImageArray.count) {
        for (UIBarButtonItem *item in self.rightItems) {
            item.tintColor = _rightImageColor;
        }
    }
}

- (void)setLeftViewArray:(NSArray<UIView *> *)leftViewArray {
    _leftViewArray = leftViewArray;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _leftViewArray.count; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_leftViewArray[i]];
        item.tag = i;
        [array addObject:item];
    }
    self.navigationItem.leftBarButtonItems = array;
    self.leftItems = array;
}

- (void)setRightViewArray:(NSArray<UIView *> *)rightViewArray {
    _rightViewArray = rightViewArray;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _rightViewArray.count; i++) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_rightViewArray[i]];
        item.tag = i;
        [array addObject:item];
    }
    self.navigationItem.rightBarButtonItems = array;
    self.rightItems = array;
}



- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

#pragma mark -------------------- item点击事件 --------------------
- (void)back {

    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftItemClick:(UIBarButtonItem *)item { }

- (void)rightItemClick:(UIBarButtonItem *)item { }

- (void)reversePush:(UIViewController *)toViewController {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:toViewController animated:NO];
}

- (void)reversePop {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
}

/** 重写touchesBegan，使视图或任何子视图的第一响应者去掉 **/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[[UIApplication sharedApplication].delegate window] endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBgGray;
    _titleFont = [UIFont systemFontOfSize:18.0f];
    _titleColor = [UIColor blackColor];

}

//- (void)addNotification:(NSNotification *)notification {
//    if ([_vc isKindOfClass:[Welcome_ViewController class]] || [_vc isKindOfClass:[Guide_ViewController class]] || [_vc isKindOfClass:[Login_SMS_ViewController class]] || [_vc isKindOfClass:[Login_Password_ViewController class]] || [_vc isKindOfClass:[Register_ViewController class]]) {
//        return;
//    }
//    NSDictionary *userInfo = [notification userInfo];
//    [AlertTool showAlertWith:self title:userInfo[@"title"] message:userInfo[@"content"] cancelButtonTitle:Localized(@"取消") destructiveButtonTitle:nil otherButtonTitles:@[Localized(@"确定")] callbackBlock:^(NSInteger btnIndex) {
//        if (btnIndex == 1) {
//            self.payModel = userInfo[@"userInfo"];
//            [self networkingForPayList];
//        }
//    }];
//
//}

- (void)setIsNotificationKeyboard:(BOOL)isNotificationKeyboard {
    _isNotificationKeyboard = isNotificationKeyboard;
    if (_isNotificationKeyboard) {
        //监听键盘弹出或收回通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc]init];
        gestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:gestureRecognizer];
    }
}

//监听键盘弹出
- (void)keyboardShow:(NSNotification *)note {
    //拿到键盘弹出的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘弹出所需时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    if (CGRectContainsPoint(keyboardFrame, self.tapPoint)) {
        frame.origin.y = - frame.size.height + keyboardFrame.origin.y;
        //添加输入框弹出和收回动画
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = frame;
        }];
    }
}

//监听键盘收起
- (void)keyboardHidden:(NSNotification *)note {
    //拿到键盘弹出的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘弹出所需时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    if (frame.origin.y < 0) {
        frame.origin.y = - frame.size.height + keyboardFrame.origin.y;
        //添加输入框弹出和收回动画
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = frame;
        }];
    }
}

//监听点击的坐标
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:kWindow];
    self.tapPoint = point;
    return NO;
}

- (void)reloadCurrentViewController {
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"异常方法--%@--%@",self,NSStringFromSelector(aSelector));
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Push_Pay" object:nil];
    NSLog(@"---%@---ViewControllerDealloc---",self);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
