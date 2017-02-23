MLTransition
============

[![Apps Using](https://img.shields.io/badge/Apps%20Using-%3E2,035-28B9FE.svg)](http://cocoapods.org/pods/MLTransition)
[![Downloads](https://img.shields.io/badge/Total%20Downloads-%3E20,113-28B9FE.svg)](http://cocoapods.org/pods/MLTransition)

Support for iOS7+.  

- Pop ViewController with pan gesture from middle or edge of screen.       
   
Tips:    
The library uses a unpublish api(not private). But it's ok in my experience. My app has been approved.

There is a sister library [MLNavigationBarTransition](https://github.com/molon/MLNavigationBarTransition)(Advanced navigation bar transition based on official push-pop transition)

**My library does not seek any reward,
but if you use this library, star it if you like. :)**

![MLTransition](https://raw.githubusercontent.com/molon/MLTransition/master/MLTransition.gif)


# Usage  

```
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOption{
[MLTransition validatePanBackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];//or MLTransitionGestureRecognizerTypeScreenEdgePan
//...
return YES;
}

```    

