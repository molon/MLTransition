//
//  MLTransitionFromLeftToRight.m
//  MLTransitionNavigationController
//
//  Created by molon on 6/28/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MLTransitionFromLeftToRight.h"
#import "MLTransitionConstant.h"

@implementation MLTransitionFromLeftToRight

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //可以理解为是动画进行中的view容器,当前fromVC.view已经在容器里了,但是toVC.view没有
    UIView *containerView = [transitionContext containerView];
    
    //获取动画时间
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    //设置toVC阴影
    toVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    toVC.view.layer.shadowOffset = CGSizeMake(kMLTransitionConstant_RightVC_ShadowOffset_Width,0);
    toVC.view.layer.shadowRadius = kMLTransitionConstant_RightVC_ShadowRadius;
    
    toVC.view.layer.shadowOpacity = kMLTransitionConstant_RightVC_ShadowOpacity;
    
    //设置初始值，即fromVC原位置，toVC在fromVC右边
    CGRect toVCFrame = fromVC.view.frame;
    toVCFrame.origin.x = CGRectGetMaxX(toVCFrame);
    toVC.view.frame = toVCFrame;
    [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
    
    //设置两者目的frame
    CGRect fromVC_toFrame = fromVC.view.frame;
    fromVC_toFrame.origin.x = -CGRectGetWidth(fromVC_toFrame)*kMLTransitionConstant_LeftVC_Move_Ratio_Of_Width; //向左移10分之3的宽度位置
    
    CGRect toVC_toFrame = fromVC.view.frame; //也就是当前fromVC.view所在位置
    
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.frame = fromVC_toFrame;
        toVC.view.frame = toVC_toFrame;
    } completion:^(BOOL finished) {
        toVC.view.layer.shadowOpacity = 0.0f;
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    //设置一个动画时间。
    return kMLTransitionConstant_TransitionDuration;
}

@end
