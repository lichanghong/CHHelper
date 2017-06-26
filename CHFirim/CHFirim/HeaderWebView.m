//
//  HeaderWebView.m
//  CHFirim
//
//  Created by lichanghong on 6/13/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "HeaderWebView.h"
#import <CHBaseUtil.h>
#import <EAIntroPage.h>
#import <EAIntroView.h>
#import <CHBaseUtil.h>

@interface HeaderWebView ()<EAIntroDelegate>

@end

@implementation HeaderWebView
{
    BOOL _logout;
    NSString *_loginedKey;
    NSString *_cacheFileName;
    NSString *_login_user_name_key;
    UIActivityIndicatorView *_activityIndicator;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self addSubview:self.webView];
         _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _activityIndicator.backgroundColor = [UIColor lightGrayColor];
        _refresh = NO;
        _logout = NO;
        [self.webView addSubview:_activityIndicator];
        _activityIndicator.center = self.webView.center;
    }
    return self;
}

- (void)setCtype:(type_class)ctype
{
    _ctype = ctype;
    
    _loginedKey = [NSString stringWithFormat:@"LOGINED_%lu",(unsigned long)ctype];
    _cacheFileName = [NSString stringWithFormat:@"html_%lu.html",(unsigned long)ctype];
    _login_user_name_key = [NSString stringWithFormat:@"login_user_name_%lu",(unsigned long)ctype];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:_loginedKey]) {
        if (!self.webView.isLoading) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[self applistURL]]];
        }
    }
    else
    {
        NSString *html = [NSString stringWithContentsOfFile:[self localFile] encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:html baseURL:nil];

    }
}

- (NSURL *)applistURL
{
    NSURL *url = nil;
    BOOL logined = [[NSUserDefaults standardUserDefaults]boolForKey:_loginedKey];

    if (_ctype == type_firim) {
        url = [NSURL URLWithString:@"https://fir.im/apps"];
    }
    else if(_ctype == type_pgyer)
    {
        if (logined) {
            url = [NSURL URLWithString:@"https://www.pgyer.com/my"];
        }
        else
            url = [NSURL URLWithString:@"https://www.pgyer.com/user/login"];
    }
    else if(_ctype == type_dafuvip)
    {
        url = [NSURL URLWithString:@"http://dafuvip.com/user/apps/index"];
    }
    return url;
}

- (void)logoutToClear
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self localFile]]) {
        NSError *error  = nil;
        [manager removeItemAtPath:[self localFile] error:&error];
        if (error) {
            [self makeToast:@"退出失败"];
        }
        [self.webView removeFromSuperview];
        _webView = nil;
        [self addSubview:self.webView];

    }
    [self deleteWebCache];
    _logout = YES;
    [[UIApplication sharedApplication].keyWindow makeToast:@"退出成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[self applistURL]]];
    });
}

- (void)deleteWebCache {
    
    if([[UIDevice currentDevice].systemVersion floatValue] >=9.0) {
        NSSet*websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate*dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
        
    }else{
        
        NSString*libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
        NSString*cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError*errors;
        [[NSFileManager defaultManager]removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}


- (void)setRefresh:(BOOL)refresh
{
    _refresh = refresh;
    if (refresh) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[self applistURL]]];
    }
    else
    {
        [self loadWithURL:[self applistURL]];
    }
}

- (void)loadWithURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if ([[NSFileManager defaultManager]fileExistsAtPath:[self localFile]]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:_loginedKey]) {
            NSString *html = [NSString stringWithContentsOfFile:[self localFile] encoding:NSUTF8StringEncoding error:nil];
            if (html) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_ctype),@"ctype",html,@"content", nil];
                NSString *postName = [NSString stringWithFormat:@"didFinishNavigation_%lu",_ctype];
                [[NSNotificationCenter defaultCenter] postNotificationName:postName object:dic];

            }
        }
        else
        {
            NSString *html = [NSString stringWithContentsOfFile:[self localFile] encoding:NSUTF8StringEncoding error:nil];
            [self.webView loadHTMLString:html baseURL:nil];
        }
    }
    else
    {
        [self.webView loadRequest:request];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:_loginedKey] && ![[NSFileManager defaultManager]fileExistsAtPath:[self localFile]] ) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"introDidFinish"])
        {
            if(!_activityIndicator.isAnimating)
            {
                [_activityIndicator startAnimating];
            }
        }
        else
        {
            NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:_login_user_name_key];
            if (username==nil) {
                [self showNavPage];
            }
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *html =[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        if (self.ctype == type_firim) {
            [self firimWeb:webView Parse:html];
        }
        else if(self.ctype == type_pgyer)
        {
            [self pgyerWeb:webView Parse:html];
        }
        else if(self.ctype == type_dafuvip)
        {
            [self dafuvipWeb:webView Parse:html];
        }
    });
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];

}



- (void)dafuvipWeb:(UIWebView *)webView Parse:(NSString *)html
{
    if ([html rangeOfString:@"loginValid"].location != NSNotFound) {
        if (_logout) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"退出成功"];
        }
        else
            [[UIApplication sharedApplication].keyWindow makeToast:@"请先登录您的大福账号"];
        
        _logout = NO;
        [_activityIndicator stopAnimating];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:_loginedKey];
        [[NSFileManager defaultManager]removeItemAtPath:[self localFile] error:nil];
    }
    else if([html rangeOfString:@"点击按钮选择应用的安装包"].location  != NSNotFound) //已登录
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_loginedKey];
        [self loadWithURL:[self applistURL]];
    }
    else
    {
        [html writeToFile:[self localFile] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if (webView==_webView) {
            [_activityIndicator stopAnimating];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_loginedKey];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_ctype),@"ctype",html,@"content", nil];
            NSString *postName = [NSString stringWithFormat:@"didFinishNavigation_%lu",_ctype];

            [[NSNotificationCenter defaultCenter] postNotificationName:postName object:dic];

        }
    }
}

- (void)pgyerWeb:(UIWebView *)webView Parse:(NSString *)html
{
    if ([html rangeOfString:@"<title>蒲公英 - 用户登录</title>"].location != NSNotFound) {
        if (_logout) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"退出成功"];
        }
        else
            [[UIApplication sharedApplication].keyWindow makeToast:@"请先登录您的蒲公英账号"];
        
        _logout = NO;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:_loginedKey];
        [[NSFileManager defaultManager]removeItemAtPath:[self localFile] error:nil];
    }
    else if([html rangeOfString:@"全程深入追踪内测过程"].location  != NSNotFound) //已登录
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_loginedKey];
        [self loadWithURL:[self applistURL]];
    }
    else
    {
        [html writeToFile:[self localFile] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if (webView==_webView) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_loginedKey];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_ctype),@"ctype",html,@"content", nil];
            NSString *postName = [NSString stringWithFormat:@"didFinishNavigation_%lu",_ctype];

            [[NSNotificationCenter defaultCenter] postNotificationName:postName object:dic];

        }
    }
    
    
    [_activityIndicator stopAnimating];

}

- (void)firimWeb:(UIWebView *)webView Parse:(NSString *)html
{
    if ([html rangeOfString:@"action=\"/signin"].location != NSNotFound) {
        if (_logout) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"退出成功"];
        }
        else
            [[UIApplication sharedApplication].keyWindow makeToast:@"请先登录您的fir账号"];
        
        _logout = NO;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:_loginedKey];
        [[NSFileManager defaultManager]removeItemAtPath:[self localFile] error:nil];
    }
    else if([html rangeOfString:@"BundleID:</td><td><"].location != NSNotFound)
    {
        [html writeToFile:[self localFile] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if (webView==_webView) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_loginedKey];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_ctype),@"ctype",html,@"content", nil];
            NSString *postName = [NSString stringWithFormat:@"didFinishNavigation_%lu",_ctype];
            [[NSNotificationCenter defaultCenter] postNotificationName:postName object:dic];

        }
    }
    else
    {
//        [self loadWithURL:[self applistURL]];
    }
    [_activityIndicator stopAnimating];

}

static bool isShow = NO;
- (void)showNavPage
{
    if (isShow) {
        return;
    }
    isShow = YES;
    // basic
    EAIntroPage *page1 = [EAIntroPage page];
    [page1 setBgImage:[UIImage imageNamed:@"bg1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    [page2 setBgImage:[UIImage imageNamed:@"bg2"]];
    EAIntroPage *page3 = [EAIntroPage page];
    [page3 setBgImage:[UIImage imageNamed:@"bg3"]];
    EAIntroPage *page4 = [EAIntroPage page];
    [page4 setBgImage:[UIImage imageNamed:@"bg4"]];

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:KScreenRect andPages:@[page1,page2,page3,page4]];
    
    [intro setDelegate:self];
    [intro showInView:[UIApplication sharedApplication].keyWindow animateDuration:0.0];
    
}

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"introDidFinish"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (NSString *)localFile
{
   NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentDir stringByAppendingPathComponent:_cacheFileName];
}


- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:KScreenRect];
        _webView.delegate = self;
        [_webView setScalesPageToFit:YES];
    }
    return _webView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
