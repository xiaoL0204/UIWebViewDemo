# UIWebViewDemo
```UIWebView```注入时机
使用```webView:didCreateJavaScriptContext:forFrame:```方法作为注入时机，比```webViewDidFinishLoad```方法**更准确、时机更早、响应更快**。
