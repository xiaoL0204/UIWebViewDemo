//
//  UICommonMacro.h
//  UIWebViewDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#ifndef UICommonMacro_h
#define UICommonMacro_h

#define SINGLETON_DEFINE(className) \
\
+ (className *)sharedInstance; \

#define SINGLETON_IMPLEMENT(className) \
\
+ (className *)sharedInstance { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0F green:G/255.0F blue:B/255.0F alpha:A]
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#endif /* UICommonMacro_h */
