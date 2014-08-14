//
//  MLBlackTransition.h
//  MLBlackTransition
//
//  Created by molon on 7/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MLBlackTransitionGestureRecognizerTypePan, //拖动模式
	MLBlackTransitionGestureRecognizerTypeScreenEdgePan, //边界拖动模式
} MLBlackTransitionGestureRecognizerType;

@interface MLBlackTransition : NSObject

+ (void)validatePanPackWithMLBlackTransitionGestureRecognizerType:(MLBlackTransitionGestureRecognizerType)type;

@end

@interface UIView(__MLBlackTransition)

//使得此view不响应拖返
@property (nonatomic, assign) BOOL disableMLBlackTransition;

@end

@interface UINavigationController(DisableMLBlackTransition)

- (void)enabledMLBlackTransition:(BOOL)enabled;

@end
