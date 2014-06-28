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
    
    //添加到容器View
    [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
    
    //从右边推进来
    toVC.view.transform = CGAffineTransformMakeTranslation(toVC.view.frame.size.width, 0);
    
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.transform = CGAffineTransformMakeTranslation(-fromVC.view.frame.size.width*kMLTransitionConstant_LeftVC_Move_Ratio_Of_Width, 0); //向左移10分之3的宽度位置
        toVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        toVC.view.layer.shadowOpacity = 0.0f;
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        fromVC.view.transform = CGAffineTransformIdentity; //重置回来,两个都重置是因为动画可能会被取消
        toVC.view.transform = CGAffineTransformIdentity;
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    //设置一个动画时间。
    return kMLTransitionConstant_TransitionDuration;
}

@end
