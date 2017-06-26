//
//  CHWXShare.h
//  CHFirim
//
//  Created by lichanghong on 6/22/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

@interface CHWXShare : NSObject<WXApiDelegate>

+ (instancetype)defaultShare;

+ (void)wxRegisterAPP:(NSString *)appid;
+ (BOOL)chHandleOpenURL:(NSURL*)url delegate:(id)delegate;

/**
 @code 分享文本消息
 */
+ (BOOL)shareWithText:(NSString *)text  TimeLine:(BOOL)ispengyouquan;

/**
 @code 分享图片消息
 */
+ (BOOL)shareWithImageData:(NSData *)data  TimeLine:(BOOL)ispengyouquan;

/**
 图片大小限制32k
@param imageName  发送之后的预览图,本地图片名
@param content 点开分享的内容之后跳转的界面
@param title 标题
@param des 标题下面的详情描述

@code 分享新闻链接消息（本地图片缩略图）
*/
+ (BOOL)sendNewsMessageWithLocalImage:(NSString *)imageName contentURL:(NSString *)content title:(NSString *)title description:(NSString *)des TimeLine:(BOOL)ispengyouquan;

/**
 图片大小限制32k
 @param imageData  发送之后的预览图,本地图片名
 @param content 点开分享的内容之后跳转的界面
 @param title 标题
 @param des 标题下面的详情描述
 
 @code 分享新闻链接消息（本地图片缩略图）
 */
+ (BOOL)sendNewsMessageWithImageData:(NSData *)imageData contentURL:(NSString *)content title:(NSString *)title description:(NSString *)des  TimeLine:(BOOL)ispengyouquan;


















@end
