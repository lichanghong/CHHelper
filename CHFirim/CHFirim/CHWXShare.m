//
//  CHWXShare.m
//  CHFirim
//
//  Created by lichanghong on 6/22/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHWXShare.h"
#import <UIImageView+WebCache.h>

@implementation CHWXShare

+ (instancetype)defaultShare
{
    static CHWXShare *share = nil;
    @synchronized (self) {
        if (!share) {
            share = [[CHWXShare alloc]init];
        }
    }
    return share;
}

+ (void)wxRegisterAPP:(NSString *)appid
{
    [WXApi registerApp:appid];
}
+ (BOOL)chHandleOpenURL:(NSURL*)url delegate:(id)delegate
{
    return [WXApi handleOpenURL:url delegate:delegate];
}

+ (BOOL)shareWithText:(NSString *)text TimeLine:(BOOL)ispengyouquan
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.text = text;
    req.bText = true;
    req.scene = ispengyouquan? WXSceneTimeline:WXSceneSession;
    return  [WXApi sendReq:req];
}

+ (BOOL)shareWithImageData:(NSData *)data TimeLine:(BOOL)ispengyouquan
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbData:data];
    WXImageObject *imageObject = [WXImageObject object];
    [imageObject setImageData:data];
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = ispengyouquan? WXSceneTimeline:WXSceneSession;
    return  [WXApi sendReq:req];
}

+ (BOOL)sendNewsMessageWithLocalImage:(NSString *)imageName contentURL:(NSString *)content title:(NSString *)title description:(NSString *)des  TimeLine:(BOOL)ispengyouquan
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    [message setThumbImage:[UIImage imageNamed:imageName]];
    
    WXWebpageObject *webpageObj = [WXWebpageObject object];
    webpageObj.webpageUrl = content;
    message.mediaObject  = webpageObj;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = ispengyouquan? WXSceneTimeline:WXSceneSession;
    return  [WXApi sendReq:req];
}



+ (BOOL)sendNewsMessageWithImageData:(NSData *)imageData contentURL:(NSString *)content title:(NSString *)title description:(NSString *)des  TimeLine:(BOOL)ispengyouquan
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    [message setThumbData:imageData];
    
    WXWebpageObject *webpageObj = [WXWebpageObject object];
    webpageObj.webpageUrl = content;
    message.mediaObject  = webpageObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = ispengyouquan? WXSceneTimeline:WXSceneSession;
    return  [WXApi sendReq:req];
}




@end
