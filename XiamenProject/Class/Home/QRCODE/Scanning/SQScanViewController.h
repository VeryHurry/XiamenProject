//
//  SQScanViewController.h
//  XiamenProject
//
//  Created by MacStudent on 2019/6/4.
//  Copyright © 2019 MacStudent. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQScanViewController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) AVCaptureDevice * device; //捕获设备，默认后置摄像头
@property (strong, nonatomic) AVCaptureDeviceInput * input; //输入设备
@property (strong, nonatomic) AVCaptureMetadataOutput * output;//输出设备，需要指定他的输出类型及扫描范围
@property (strong, nonatomic) AVCaptureSession * session; //AVFoundation框架捕获类的中心枢纽，协调输入输出设备以获得数据
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;//展示捕获图像的图层，是CALayer的子类

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGes;//缩放手势
//扫描框
@property (nonatomic,strong)UIImageView *imageView;

//扫描线
@property (nonatomic,retain)UIImageView *line;


@end

NS_ASSUME_NONNULL_END
