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
@property (assign, nonatomic) BOOL isChange;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    {
//        //在创建webview之前就定义好全局的userAgent
//        self.webView = [[UIWebView alloc] init];//新建webview是为了获取旧的userAgent
//        NSString* secretAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//        NSLog(@"webView旧的userAgent：%@",secretAgent);
//        
//        NSRange range = [secretAgent rangeOfString:@"mjd_cridit_native"];
//        if(range.length == 0){
//            NSString *newUagent = [NSString stringWithFormat:@"%@ %@",secretAgent,@"mjd_cridit_native"];
//            NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:newUagent, @"UserAgent",nil];
//            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
//        }
//        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//        self.webView.scalesPageToFit = YES;
//        [self.view addSubview:self.webView];
//        secretAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//        NSLog(@"webView新的userAgent：%@",secretAgent);
//    }
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIInterfaceOrientation status;
    if (self.isChange) {
        self.isChange = NO;
        status = UIInterfaceOrientationPortrait;
    } else {
        self.isChange = YES;
        status = UIInterfaceOrientationLandscapeRight;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarOrientation:status animated:NO];
#pragma clang diagnostic pop
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
