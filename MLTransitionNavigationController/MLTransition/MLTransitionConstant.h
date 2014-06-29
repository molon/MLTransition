//
//  MLTransitionConstant.h
//  MLTransitionNavigationController
//
//  Created by molon on 6/28/14.
//  Copyright (c) 2014 molon. All rights reserved.
//


#ifndef MLTransitionConstant_h
#define MLTransitionConstant_h

//通常意义上的动画时间
#define kMLTransitionConstant_TransitionDuration 0.25f

//左VC移动的长度和其整个宽度的比例
#define kMLTransitionConstant_LeftVC_Move_Ratio_Of_Width 0.3f

//阴影相关
#define kMLTransitionConstant_RightVC_ShadowOffset_Width (-0.4f)
#define kMLTransitionConstant_RightVC_ShadowRadius 3.0f
#define kMLTransitionConstant_RightVC_ShadowOpacity 0.3f

//有效的向右拖动的最小速率，即为大于这个速率就认为想返回上一页罢了
#define kMLTransitionConstant_Valid_MIN_Velocity 300.0f

#endif
