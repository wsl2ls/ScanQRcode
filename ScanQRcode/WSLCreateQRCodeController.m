//
//  WSLCreateQRCodeController.m
//  ScanQRcode
//
//  Created by 王双龙 on 2018/3/1.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import "WSLCreateQRCodeController.h"

@interface WSLCreateQRCodeController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation WSLCreateQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"生成二维码";
    self.imageView.image = self.qrImage;
    self.label.text = [NSString stringWithFormat:@"扫描结果：%@ ",self.qrString];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel)];
    [self.label addGestureRecognizer:tap];
    [self.imageView addGestureRecognizer:tap];
}

- (void)tapLabel{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.qrString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
