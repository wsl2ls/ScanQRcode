# WSLNativeScanTool

![](https://img.shields.io/badge/license-MIT%20-green.svg)
![](https://img.shields.io/badge/pod-v1.0-brightgreen.svg)
![](https://img.shields.io/badge/platform-iOS-orange.svg)
![](https://img.shields.io/badge/support-iOS9.0-green.svg)
![](https://img.shields.io/badge/build-passing-green.svg)


![效果预览1.gif](http://upload-images.jianshu.io/upload_images/1708447-6f8d911290ccafb4.gif?imageMogr2/auto-orient/strip) ![效果预览2.gif](http://upload-images.jianshu.io/upload_images/1708447-70b61f5542fc07a1.gif?imageMogr2/auto-orient/strip)

>功能描述:[WSLNativeScanTool](https://github.com/wslcmk/ScanQRcode.git)是在利用原生API的条件下封装的二维码扫描工具，支持二维码的扫描、识别图中二维码、生成自定义颜色和中心图标的二维码、监测环境亮度、打开闪光灯这些功能；[WSLScanView](https://github.com/wslcmk/ScanQRcode.git)是参照微信封装的一个扫一扫界面，支持线条颜色、大小、动画图片、矩形扫描框样式的自定义；这个示例本身就是仿照微信的扫一扫功能实现的。

* 详细实现就不在此唠叨了，直接去看代码吧，注释详细是我的习惯😀→[WSLNativeScanTool](https://github.com/wslcmk/ScanQRcode.git)
* 来看一下WSLNativeScanTool.h ，用法很明朗
```
@import UIKit;
@import AVFoundation;

#import <Foundation/Foundation.h>

/**
 扫描完成的回调
 @param scanString 扫描出的字符串
 */
typedef void(^WSLScanFinishedBlock)( NSString * _Nullable scanString);

/**
 监听环境光感的回调
 @param brightness 亮度值
 */
typedef void(^WSLMonitorLightBlock)( float brightness);

@interface WSLNativeScanTool : NSObject

/**
 扫描出结果后的回调 ，注意循环引用的问题
 */
@property (nonatomic, copy) WSLScanFinishedBlock _Nullable scanFinishedBlock;

/**
 监听环境光感的回调,如果 != nil 表示开启监测环境亮度功能
 */
@property (nonatomic, copy) WSLMonitorLightBlock _Nullable monitorLightBlock;

/**
 闪光灯的状态,不需要设置，仅供外边判断状态使用
 */
@property (nonatomic, assign) BOOL flashOpen;

/**
 初始化 扫描工具
 @param preview 展示输出流的视图
 @param scanFrame 扫描中心识别区域范围
 */
- (instancetype )initWithPreview:(UIView *)preview andScanFrame:(CGRect)scanFrame;

/**
 闪光灯开关
 */
- (void)openFlashSwitch:(BOOL)open;

- (void)sessionStartRunning;

- (void)sessionStopRunning;

/**
 识别图中二维码
 */
- (void)scanImageQRCode:(UIImage *_Nullable)imageCode;

/**
 生成自定义样式二维码
 注意：有些颜色结合生成的二维码识别不了
 @param codeString 字符串
 @param size 大小
 @param backColor 背景色
 @param frontColor 前景色
 @param centerImage 中心图片
 @return image二维码
 */
+ (UIImage *)createQRCodeImageWithString:(nonnull NSString *)codeString andSize:(CGSize)size andBackColor:(nullable UIColor *)backColor andFrontColor:(nullable UIColor *)frontColor andCenterImage:(nullable UIImage *)centerImage;

```
* 再来看一下WSLScanView.h,用法也明朗😁

```
//
//  WSLScanView.h
//  ScanQRcode
//
//  Created by 王双龙 on 2018/2/28.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea
All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WSLMyQRCodeBlock)(void);

typedef void(^WSLFlashSwitchBlock)(BOOL open);

@interface WSLScanView : UIView

/**
 点击我的二维码的回调
 */
@property (nonatomic,copy) WSLMyQRCodeBlock myQRCodeBlock;

/**
 打开/关闭闪光灯的回调
 */
@property (nonatomic,copy) WSLFlashSwitchBlock flashSwitchBlock;

#pragma mark - 扫码区域

/**
 扫码区域 默认为正方形,x = 60, y = 100
 */
@property (nonatomic,assign)CGRect scanRetangleRect;
/**
 @brief  是否需要绘制扫码矩形框，默认YES
 */
@property (nonatomic, assign) BOOL isNeedShowRetangle;
/**
 @brief  矩形框线条颜色
 */
@property (nonatomic, strong, nullable) UIColor *colorRetangleLine;

#pragma mark - 矩形框(扫码区域)周围4个角

//4个角的颜色
@property (nonatomic, strong, nullable) UIColor* colorAngle;
//扫码区域4个角的宽度和高度 默认都为20
@property (nonatomic, assign) CGFloat photoframeAngleW;
@property (nonatomic, assign) CGFloat photoframeAngleH;
/**
 @brief  扫码区域4个角的线条宽度,默认6
 */
@property (nonatomic, assign) CGFloat photoframeLineW;

#pragma mark --动画效果

/**
 *  动画效果的图像
 */
@property (nonatomic,strong, nullable) UIImage * animationImage;
/**
 非识别区域颜色,默认 RGBA (0,0,0,0.5)
 */
@property (nonatomic, strong, nullable) UIColor * notRecoginitonArea;

/**
 *  开始扫描动画
 */
- (void)startScanAnimation;
/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;

/**
 正在处理扫描到的结果
 */
- (void)handlingResultsOfScan;

/**
 完成扫描结果处理
 */
- (void)finishedHandle;

/**
 是否显示闪光灯开关
 @param show YES or NO
 */
- (void)showFlashSwitch:(BOOL)show;
@end

```

*  初始化WSLNativeScanTool和WSLScanView

```
//输出流视图
    UIView *preview  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
    [self.view addSubview:preview];
    
    __weak typeof(self) weakSelf = self;
    
    //构建扫描样式视图
    _scanView = [[WSLScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
    _scanView.scanRetangleRect = CGRectMake(60, 120, (self.view.frame.size.width - 2 * 60),  (self.view.frame.size.width - 2 * 60));
    _scanView.colorAngle = [UIColor greenColor];
    _scanView.photoframeAngleW = 20;
    _scanView.photoframeAngleH = 20;
    _scanView.photoframeLineW = 2;
    _scanView.isNeedShowRetangle = YES;
    _scanView.colorRetangleLine = [UIColor whiteColor];
    _scanView.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _scanView.animationImage = [UIImage imageNamed:@"scanLine"];
    _scanView.myQRCodeBlock = ^{
     [WSLNativeScanTool createQRCodeImageWithString:@"https://www.jianshu.com/u/e15d1f644bea" andSize:CGSizeMake(250, 250) andBackColor:[UIColor whiteColor] andFrontColor:[UIColor orangeColor] andCenterImage:[UIImage imageNamed:@"piao"]];
        createQRCodeController.qrString = @"https://www.jianshu.com/u/e15d1f644bea";
    };
    _scanView.flashSwitchBlock = ^(BOOL open) {
        [weakSelf.scanTool openFlashSwitch:open];
    };
    [self.view addSubview:_scanView];
    
    //初始化扫描工具
    _scanTool = [[WSLNativeScanTool alloc] initWithPreview:preview andScanFrame:_scanView.scanRetangleRect];
    _scanTool.scanFinishedBlock = ^(NSString *scanString) {
        NSLog(@"扫描结果 %@",scanString);
        [weakSelf.scanTool sessionStopRunning];
        [weakSelf.scanTool openFlashSwitch:NO];
    };
    _scanTool.monitorLightBlock = ^(float brightness) {
        NSLog(@"环境光感 ： %f",brightness);
        if (brightness < 0) {
            // 环境太暗，显示闪光灯开关按钮
            [weakSelf.scanView showFlashSwitch:YES];
        }else if(brightness > 0){
            // 环境亮度可以,且闪光灯处于关闭状态时，隐藏闪光灯开关
            if(!weakSelf.scanTool.flashOpen){
                [weakSelf.scanView showFlashSwitch:NO];
            }
        }
    };
    [_scanTool sessionStartRunning];
    [_scanView startScanAnimation];
    
```
简书地址：https://www.jianshu.com/u/e15d1f644bea
![赞.gif](http://upload-images.jianshu.io/upload_images/1708447-ce06388c244874ce.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
