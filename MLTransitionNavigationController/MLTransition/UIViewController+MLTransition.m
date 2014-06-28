//
//  UIViewController+MLTransition.m
//  MLTransitionNavigationController
//
//  Created by molon on 6/28/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "UIViewController+MLTransition.h"
#import <objc/runtime.h>
#import "MLTransitionFromRightToLeft.h"
#import "MLTransitionFromLeftToRight.h"
#import "MLTransitionConstant.h"

NSString * const kMLTransition_PercentDrivenInteractivePopTransition = @"__MLTransition_PercentDrivenInteractivePopTransition";

//设置一个默认的全局使用的type
static MLTransitionGestureRecognizerType __MLTransitionGestureRecognizerType = MLTransitionGestureRecognizerTypePan;

//静态就交换静态，实例方法就交换实例方法
void __MLTransition_Swizzle(Class c, SEL origSEL, SEL newSEL)
{
    //获取实例方法
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = nil;
	if (!origMethod) {
        //获取静态方法
		origMethod = class_getClassMethod(c, origSEL);
        newMethod = class_getClassMethod(c, newSEL);
    }else{
        newMethod = class_getInstanceMethod(c, newSEL);
    }
    
    if (!origMethod||!newMethod) {
        return;
    }
    
    //自身已经有了就添加不成功，直接交换即可
    if(class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        //添加成功一般情况是因为，origSEL本身是在c的父类里。这里添加成功了一个继承方法。
        class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
	}
}

@interface UIViewController ()

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenInteractivePopTransition;

@end

@implementation UIViewController (MLTransition)

#pragma mark - outside call
+ (void)validateWithMLTransitionGestureRecognizerType:(MLTransitionGestureRecognizerType)type
{
    //整个程序的生命周期只允许执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //设置记录type,并且执行hook
        __MLTransitionGestureRecognizerType = type;
        
        __MLTransition_Swizzle([self class],@selector(viewDidLoad),@selector(__MLTransition_Hook_ViewDidLoad));
        __MLTransition_Swizzle([self class],@selector(viewDidAppear:),@selector(__MLTransition_Hook_ViewDidAppear:));
        __MLTransition_Swizzle([self class],@selector(viewWillDisappear:),@selector(__MLTransition_Hook_ViewWillDisappear:));
    });
}

#pragma mark - add property
- (void)setPercentDrivenInteractivePopTransition:(UIPercentDrivenInteractiveTransition *)percentDrivenInteractivePopTransition
{
    [self willChangeValueForKey:kMLTransition_PercentDrivenInteractivePopTransition];
	objc_setAssociatedObject(self, &kMLTransition_PercentDrivenInteractivePopTransition, percentDrivenInteractivePopTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kMLTransition_PercentDrivenInteractivePopTransition];
}

- (UIPercentDrivenInteractiveTransition *)percentDrivenInteractivePopTransition
{
	return objc_getAssociatedObject(self, &kMLTransition_PercentDrivenInteractivePopTransition);
}

#pragma mark - hook
- (void)__MLTransition_Hook_ViewDidLoad
{
    [self __MLTransition_Hook_ViewDidLoad];
    
    if (__MLTransitionGestureRecognizerType == MLTransitionGestureRecognizerTypeScreenEdgePan) {
        UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(__MLTransition_HandlePopRecognizer:)];
        gestureRecognizer.edges = UIRectEdgeLeft;
        [self.view addGestureRecognizer:gestureRecognizer];
    }else{
        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(__MLTransition_HandlePopRecognizer:)]];
    }
}

- (void)__MLTransition_Hook_ViewDidAppear:(BOOL)animated {
    [self __MLTransition_Hook_ViewDidAppear:animated];
    
    if (![self isKindOfClass:[UINavigationController class]]) {
        self.navigationController.delegate = self;
    }
}

- (void)__MLTransition_Hook_ViewWillDisappear:(BOOL)animated {
    [self __MLTransition_Hook_ViewWillDisappear:animated];
    
    if (![self isKindOfClass:[UINavigationController class]]) {
        if (self.navigationController.delegate == self) {
            self.navigationController.delegate = nil;
        }
    }
}


#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (fromVC == self) {
        if (operation == UINavigationControllerOperationPop) {
            return [[MLTransitionFromRightToLeft alloc]init];
        }else{
            return [[MLTransitionFromLeftToRight alloc]init];
        }
    }else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[MLTransitionFromRightToLeft class]]) {
        return self.percentDrivenInteractivePopTransition;
    }
    else {
        return nil;
    }
}

#pragma mark - UIGestureRecognizer handlers
- (void)__MLTransition_HandlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    //如果没有导航器或者是导航器第一个就忽略
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (!self.navigationController||[self.navigationController.viewControllers[0] isEqual:self]) {
            return;
        }
    }
    
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0f);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //如果不是开始就横向拉就忽略
        if (progress<=0) {
            return;
        }
        //建立一个transition的百分比控制对象
        self.percentDrivenInteractivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged&&self.percentDrivenInteractivePopTransition) {
        //根据拖动调整transition状态
        [self.percentDrivenInteractivePopTransition updateInteractiveTransition:progress];
    }else if ((recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)&&self.percentDrivenInteractivePopTransition) {
        //结束或者取消了手势，根据方向和速率来判断应该完成transition还是取消transition
        CGFloat velocity = [recognizer velocityInView:self.view].x; //我们只关心x的速率
        
        if (velocity > kMLTransitionConstant_Valid_MIN_Velocity) { //向右速率太快就完成
            [self.percentDrivenInteractivePopTransition finishInteractiveTransition];
        }else if (velocity < -kMLTransitionConstant_Valid_MIN_Velocity){ //向左速率太快就取消
            [self.percentDrivenInteractivePopTransition cancelInteractiveTransition];
        }else{
            if (progress < 0.2) {
                [self.percentDrivenInteractivePopTransition cancelInteractiveTransition];
            }else if (progress > 0.7) {
                [self.percentDrivenInteractivePopTransition finishInteractiveTransition];
            }else{
                //在中间区域，如果向左速率稍大，就取消，否则就完成
                if (velocity < -5.0f) {
                    self.percentDrivenInteractivePopTransition.completionSpeed /= 3.5;
                    [self.percentDrivenInteractivePopTransition cancelInteractiveTransition];
                }else{
                    self.percentDrivenInteractivePopTransition.completionSpeed /= 2.5;
                    [self.percentDrivenInteractivePopTransition finishInteractiveTransition];
                }
            }
        }
        self.percentDrivenInteractivePopTransition = nil;
    }
    
}



@end
