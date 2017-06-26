//
//  CHQQShare.m
//  CHShareUtil
//
//  Created by lichanghong on 6/15/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHQQShare.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface CHQQShare ()

@end
//定向分享：分享文本消息，分享图片消息，分享新闻链接消息（网络图片缩略图），分享新闻链接消息（本地图片缩略图），
//分享音乐链接消息（本地图片缩略图），分享视频链接消息（本地图片缩略图），发送图片到我的电脑（本地图片）

@implementation CHQQShare

+ (void)registerWithAppid:(NSString *)appid{
    TencentOAuth*auth=[[TencentOAuth alloc] initWithAppId:appid andDelegate:nil];
    [auth getVipInfo];
}

//分享文本消息
+ (SendResultCode)shareWithText:(NSString *)text
{
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    return (SendResultCode)sent;
}
//分享图片消息
+ (SendResultCode)shareWithImageData:(NSData *)data
{
    QQApiImageObject* img = [QQApiImageObject objectWithData:data previewImageData:data title:@"" description:@""];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    return (SendResultCode)sent;
}
//分享新闻链接消息（网络图片缩略图）
+ (SendResultCode)sendNewsMessageWithImageURL:(NSString *)URLStr contentURL:(NSString *)content title:(NSString *)title description:(NSString *)des
{
    NSURL *previewURL = [NSURL URLWithString:URLStr];
    NSURL* url = [NSURL URLWithString:content];
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:des previewImageURL:previewURL];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    return (SendResultCode)[QQApiInterface sendReq:req];
    
}


//分享新闻链接消息（本地图片缩略图）
+ (SendResultCode)sendNewsMessageWithLocalImage:(NSString *)imageName contentURL:(NSString *)content title:(NSString *)title description:(NSString *)des
{
    NSData* data = UIImagePNGRepresentation([UIImage imageNamed:imageName]);
    NSURL* url = [NSURL URLWithString:content];
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:des previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    return (SendResultCode)[QQApiInterface sendReq:req];
}


//分享图片/纯文本到QZone  @param imageDataArray 发送的多张图片队列
+ (SendResultCode)shareForQZoneTitle:(NSString *)title ImageDataArray:(NSArray *)images
{
    QQApiImageArrayForQZoneObject *obj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:images title:title];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
    return (SendResultCode)[QQApiInterface SendReqToQZone:req];
}
 

@end
