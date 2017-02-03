//
//  NSObject+Category.m
//  UIWebViewDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#import "NSObject+Category.h"
#import "WebViewDelegateManager.h"

@class JSContext;

@implementation NSObject (Category)

//webView:WebView      frame : WebFrame
-(void)webView:(id)webView didCreateJavaScriptContext:(JSContext *)context forFrame:(id)frame{
    if ([[WebViewDelegateManager sharedInstance] respondsToSelector:@selector(webView:didCreateJavaScriptContext:forFrame:)]) {
        [[WebViewDelegateManager sharedInstance] webView:webView didCreateJavaScriptContext:context forFrame:frame];
    }
}

@end
