//
//  MSSortView.h
//  CoreText进阶封装
//
//  Created by msj on 2018/1/11.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSView : UIView
@property (assign, nonatomic) NSInteger row;  // 行号
@property (assign, nonatomic) NSInteger col;  // 列号
@property (assign, nonatomic) CGRect endFrame; //最终Frame
@end

@interface MSSortView : UIView
@property (assign, nonatomic) NSInteger count;
@property (copy, nonatomic) void (^clickBlock)(MSView *view);
@end
