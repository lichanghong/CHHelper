//
//  HeaderWebView.h
//  CHFirim
//
//  Created by lichanghong on 6/13/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Header.h"



@interface HeaderWebView : UIView<UIWebViewDelegate,NSURLSessionTaskDelegate>
@property (nonatomic,assign)type_class ctype;

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,assign)BOOL refresh;

 
- (void)logoutToClear;

@end
