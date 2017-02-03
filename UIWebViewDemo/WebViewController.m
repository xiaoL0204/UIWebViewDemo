//
//  WebViewController.m
//  UIWebViewDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewDelegateManager.h"

@import JavaScriptCore;


@interface WebViewController () <UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) JSContext *jsContext;

@end

@implementation WebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[WebViewDelegateManager sharedInstance] setWebDelegate:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.urlString) {
        self.urlString = @"https://www.baidu.com";
    }
    
    [self initilizeWebView];
    
    
}


-(void)initilizeWebView{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    self.webView.backgroundColor = RGBA(250, 250, 250, 1);
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor lightGrayColor];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.alwaysBounceVertical = NO;
    [self.view addSubview:self.webView];
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:mutableRequest];
}


//frame : WebFrame
-(void)webView:(id)webView didCreateJavaScriptContext:(JSContext *)context forFrame:(id)frame{
    NSLog(@"[%@]  didCreateJavaScriptContext   inject",NSStringFromClass([self class]));
    [self getJsContext];
    
    [self changeJavascriptBackMethod:context];
    [self changeJavaScriptStateChangeMethod:context];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"[%@]  webViewDidStartLoad",NSStringFromClass([self class]));
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"[%@]  webViewDidFinishLoad",NSStringFromClass([self class]));

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"[%@]  didFailLoadWithError:%@",NSStringFromClass([self class]),error);
}


-(void)popSelf{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark - javascript上下文
-(void)getJsContext{
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
}
#pragma mark - 返回按钮
-(void)changeJavascriptBackMethod:(JSContext *)context{
    NSString *jsString1 = @"function historyBack(){}";
    NSString *jsString2 = @"window.history.back=function(){historyBack();}";
    [context evaluateScript:jsString1];
    [context evaluateScript:jsString2];
    
    __weak __block typeof(self) weakSelf = self;
    context[@"historyBack"] = ^{
        [weakSelf performSelectorOnMainThread:@selector(popSelf) withObject:nil waitUntilDone:NO];
        //        [weakSelf popSelf];
    };
}

#pragma mark - doc状态改变
-(void)changeJavaScriptStateChangeMethod:(JSContext *)context{
    NSString *jsString1 = @"function onreadystatechange(){}";
    NSString *jsString2 = @"document.onreadystatechange=function(){onreadystatechange();}";
    [context evaluateScript:jsString1];
    [context evaluateScript:jsString2];
    
    WeakSelf(ws);
    
    self.jsContext[@"onreadystatechange"] = ^{
        JSValue *readyStateValue = [context evaluateScript:@"document.readyState"];
        if ([[readyStateValue toString] isEqualToString:@"interactive"]) {
            if ([ws respondsToSelector:@selector(changeJsMethodAddLike:)]) {
                [ws changeJsMethodAddLike:context];
            }
        }
        
    };
    
}


-(void)changeJsMethodAddLike:(JSContext *)context{
    __block BOOL isNotLogin = NO;
    __weak __block typeof(self) weakSelf = self;
    context[@"addLike"] = ^{
        NSArray *arguments = [JSContext currentArguments];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isNotLogin) {
                
                
                return;
            }
        });
    };
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
