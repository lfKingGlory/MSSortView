//
//  ViewController.m
//  MSSortView
//
//  Created by msj on 2018/1/11.
//  Copyright © 2018年 mjsfax. All rights reserved.
//

#import "ViewController.h"
#import "MSSortView.h"
#import "UIView+FrameUtil.h"

@interface ViewController ()
@property (strong, nonatomic) MSSortView *sView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    NSInteger count = 7;
    CGFloat padding = 30;
    NSInteger rows = count/3 + count%3;
    CGFloat w = 50*3 + padding*4;
    CGFloat h = 50*rows + padding*(rows+1);
    CGFloat x = (screenW - w)/2.0;
    CGFloat y = (screenH - h)/2.0;
    self.sView = [[MSSortView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.sView.layer.cornerRadius = 8;
    self.sView.backgroundColor = [UIColor grayColor];
    self.sView.count = count;
    [self.view addSubview:self.sView];
    self.sView.clickBlock = ^(MSView *view) {
        NSLog(@"tag===%d===row===%d===col===%d",(int)view.tag,(int)view.row,(int)view.col);
    };
}

@end
