//
//  MSSortView.m
//  CoreText进阶封装
//
//  Created by msj on 2018/1/11.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "MSSortView.h"
#import "UIView+FrameUtil.h"

#pragma mark - MSView
@implementation MSView
@end

#pragma mark - MSSortView
@interface MSSortView ()
@property (strong, nonatomic) MSView *currentSelectedView;
@property (assign, nonatomic) CGPoint startPoint;
@property (strong, nonatomic) NSMutableArray <MSView *>*views;
@property (assign, nonatomic) BOOL isMoved;
@end

@implementation MSSortView
#pragma mark - life
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _views = [NSMutableArray array];
        _isMoved = NO;
    }
    return self;
}

#pragma mark - Public
- (void)setCount:(NSInteger)count {
    _count = count;
    
    if (self.views.count) {
        [self.views makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.views removeAllObjects];
    }
    
    CGFloat padding = 30;
    CGFloat w = 50;
    CGFloat h = 50;
    for (int i = 0; i < count; i++) {
        CGFloat x = (padding + w) * (i%3) + padding;
        CGFloat y = (padding + h) * (i/3) + padding;
        MSView *view = [[MSView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        view.tag = i;
        view.row = i/3;
        view.col = i%3;
        view.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        view.endFrame = view.frame;
        view.exclusiveTouch = YES;
        view.layer.cornerRadius = 4;
        [self addSubview:view];
        [self.views addObject:view];
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.currentSelectedView) {
        return;
    }
    self.isMoved = NO;
    UITouch *touch = touches.anyObject;
    CGPoint startPoint = [touch locationInView:self];
    self.startPoint = startPoint;
    MSView *iView = [self getViewWithPoint:startPoint];
    if (iView) {
        self.currentSelectedView = iView;
        [self bringSubviewToFront:self.currentSelectedView];
        [UIView animateWithDuration:0.25 animations:^{
            iView.transform = CGAffineTransformMakeScale(1.15, 1.15);
        }];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.currentSelectedView) {
        return;
    }
    self.isMoved = YES;
    UITouch *touch = touches.anyObject;
    CGPoint movePoint = [touch locationInView:self];
    CGPoint distancePoint = CGPointMake(movePoint.x - self.startPoint.x, movePoint.y - self.startPoint.y);
    self.currentSelectedView.centerX += distancePoint.x;
    self.currentSelectedView.centerY += distancePoint.y;
    self.startPoint = movePoint;
    
    MSView *mixDistanceView = [self getMixDistanceViewFromCurrentSelectedView];
    if (mixDistanceView) {
        CGFloat d = [self calculateDistanceWithPoint:mixDistanceView.center otherPoint:self.currentSelectedView.center];
        if (d < 40) {
            if (mixDistanceView.row == self.currentSelectedView.row) {  // 同行
                [UIView animateWithDuration:0.25 animations:^{
                    [self changeEndFrameWithMixDistanceView:mixDistanceView currentSelectedView:self.currentSelectedView];
                }];
            } else {  // 跨行
                NSInteger mixDistanceViewTag = mixDistanceView.tag;
                NSInteger iViewTag = self.currentSelectedView.tag;
                if (iViewTag > mixDistanceViewTag) {
                    for (NSInteger i = iViewTag - 1; i >= mixDistanceViewTag; i--) {
                        MSView *v = self.views[i];
                        [UIView animateWithDuration:0.25 animations:^{
                            [self changeEndFrameWithMixDistanceView:v currentSelectedView:self.currentSelectedView];
                        }];
                    }
                } else {
                    for (NSInteger i = iViewTag + 1; i <= mixDistanceViewTag; i++) {
                        MSView *v = self.views[i];
                        [UIView animateWithDuration:0.25 animations:^{
                            [self changeEndFrameWithMixDistanceView:v currentSelectedView:self.currentSelectedView];
                        }];
                    }
                }
            }
        }
    }
    
    if (self.currentSelectedView.x < 0 || self.currentSelectedView.x > self.width-self.currentSelectedView.width || self.currentSelectedView.y < 0 || self.currentSelectedView.y > self.height-self.currentSelectedView.height) {
        [self endDrag];
        self.isMoved = YES;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self checkIsMoved];
    [self endDrag];
    self.isMoved = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self checkIsMoved];
    [self endDrag];
    self.isMoved = NO;
}

#pragma mark - Private
- (void)checkIsMoved {
    if (!self.isMoved) {
        if (self.currentSelectedView) {
            if (self.clickBlock) {
                self.clickBlock(self.currentSelectedView);
            }
        }
    }
}

- (void)endDrag {
    if (self.currentSelectedView) {
        [UIView animateWithDuration:0.25 animations:^{
            self.currentSelectedView.transform = CGAffineTransformIdentity;
            self.currentSelectedView.frame = self.currentSelectedView.endFrame;
        }];
        self.currentSelectedView = nil;
    }
}

- (void)changeEndFrameWithMixDistanceView:(MSView *)mixDistanceView currentSelectedView:(MSView *)currentSelectedView {
    
    [self.views exchangeObjectAtIndex:mixDistanceView.tag withObjectAtIndex:currentSelectedView.tag];
    
    NSInteger tag = currentSelectedView.tag;
    currentSelectedView.tag = mixDistanceView.tag;
    mixDistanceView.tag = tag;
    
    NSInteger row = currentSelectedView.row;
    currentSelectedView.row = mixDistanceView.row;
    mixDistanceView.row = row;
    
    NSInteger col = currentSelectedView.col;
    currentSelectedView.col = mixDistanceView.col;
    mixDistanceView.col = col;
    
    CGRect endFrame = currentSelectedView.endFrame;
    currentSelectedView.endFrame = mixDistanceView.endFrame;
    mixDistanceView.endFrame = endFrame;
    mixDistanceView.frame = endFrame;
}

- (MSView *)getViewWithPoint:(CGPoint)point {
    for (MSView *view in self.views) {
        if (CGRectContainsPoint(view.frame, point)) {
            return view;
        }
    }
    return nil;
}

- (MSView *)getMixDistanceViewFromCurrentSelectedView {
    CGFloat distance = CGFLOAT_MAX;
    MSView *mixDistanceView = nil;
    for (MSView *view in self.views) {
        if (view == self.currentSelectedView) {
            continue;
        }
        CGFloat d = [self calculateDistanceWithPoint:view.center otherPoint:self.currentSelectedView.center];
        if (d < distance) {
            distance = d;
            mixDistanceView = view;
        }
    }
    return mixDistanceView;
}

- (CGFloat)calculateDistanceWithPoint:(CGPoint)p1 otherPoint:(CGPoint)p2 {
    return sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));
}

#pragma mark - debug
- (void)test {
    for (MSView *v in self.views) {
        NSLog(@"tag===%d===row===%d===col===%d",(int)v.tag,(int)v.row,(int)v.col);
    }
}
@end
