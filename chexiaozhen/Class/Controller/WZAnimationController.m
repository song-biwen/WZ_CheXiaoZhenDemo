//
//  WZAnimationController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/7/6.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZAnimationController.h"

@interface WZAnimationController ()
//添加动画的对象
@property (weak, nonatomic) IBOutlet UIView *orange_view;

@end

@implementation WZAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//按钮点击事件
- (IBAction)buttonAction:(id)sender {
    
//    // 设置values**********************
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
//    
//    // 设置动画属性
//    anim.keyPath = @"position";
//    
//    CGPoint point = self.orange_view.center;
//    
//    NSValue *v1 = [NSValue valueWithCGPoint:point];
//    
//    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(point.x + 20, point.y - 20)];
//    
//    NSValue *v3 = [NSValue valueWithCGPoint:point];
//    
//    anim.values = @[v1,v2,v3];
//    
//    anim.duration = 2;
//    anim.removedOnCompletion = YES;
//    
//    [self.orange_view.layer addAnimation:anim forKey:nil];
    
    
//    //设置path************************
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
//    
//    // 设置动画属性
//    anim.keyPath = @"position";
//    
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
//    
//    anim.path = path.CGPath;
//    
//    anim.duration = 0.25;
//    
//    // 取消反弹
//    anim.removedOnCompletion = NO;
//    
//    anim.fillMode = kCAFillModeForwards;
//    
//    anim.repeatCount = MAXFLOAT;
//    
//    [self.orange_view.layer addAnimation:anim forKey:nil];
    
    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//    
//    animation.keyPath = @"position";
//    
//    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
//    
//    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(200, 100)];
//    
//    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(200, 200)];
//    
//    NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(100, 200)];
//    
//    NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
//    
//    animation.values=@[value1,value2,value3,value4,value5];
//    animation.repeatCount=MAXFLOAT;
//    
//    animation.removedOnCompletion = NO;
//    
//    animation.fillMode = kCAFillModeRemoved;
//    
//    animation.duration = 4.0f;
//    
//    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    animation.delegate=self;
//    
//    [self.orange_view.layer addAnimation:animation forKey:nil];
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [self.orange_view.layer addAnimation:k forKey:nil];
    
}
@end
