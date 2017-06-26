//
//  CHQQShare.h
//  CHShareUtil
//
//  Created by lichanghong on 6/15/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
   APISENDSUCESS = 0,
   APIQQNOTINSTALLED = 1,
   APIQQNOTSUPPORTAPI = 2,
   APIMESSAGETYPEINVALID = 3,
   APIMESSAGECONTENTNULL = 4,
   APIMESSAGECONTENTINVALID = 5,
   APIAPPNOTREGISTED = 6,
   APIAPPSHAREASYNC = 7,
   APIQQNOTSUPPORTAPI_WITH_ERRORSHOW = 8,
   APISENDFAILD = -1,
   APISHAREDESTUNKNOWN = -2, //未指定分享到QQ或TIM
    
   APITIMNOTINSTALLED = 11, //TIM未安装
   APITIMNOTSUPPORTAPI = 12, // TIM api不支持
    //qzone分享不支持text类型分享
   APIQZONENOTSUPPORTTEXT = 10000,
    //qzone分享不支持image类型分享
   APIQZONENOTSUPPORTIMAGE = 10001,
    //当前QQ版本太低，需要更新至新版本才可以支持
   APIVERSIONNEEDUPDATE = 10002,
    IMAPIVERSIONNEEDUPDATE = 10004,
} SendResultCode;


@interface CHQQShare : NSObject 

+ (void)registerWithAppid:(NSString *)appid;

/**
 @code 分享文本消息
*/
+ (SendResultCode)shareWithText:(NSString *)text;

/**
 @code 分享图片消息
 */
+ (SendResultCode)shareWithImageData:(NSData *)data ;


/**
 @param URLStr  发送之后的预览图
 @param content 点开分享的内容之后跳转的界面
 @param title 标题
 @param des 标题下面的详情描述
 
 @code 分享新闻链接消息（网络图片缩略图）
 */
+ (SendResultCode)sendNewsMessageWithImageURL:(NSString *)URLStr contentURL:(NSString *)content title:(NSString *)title description:(NSString *)des;

/**
 @param imageName  发送之后的预览图,本地图片名
 @param content 点开分享的内容之后跳转的界面
 @param title 标题
 @param des 标题下面的详情描述
 
 @code 分享新闻链接消息（本地图片缩略图）
 */
+ (SendResultCode)sendNewsMessageWithLocalImage:(NSString *)imageName contentURL:(NSString *)content title:(NSString *)title description:(NSString *)des;




// -------------------------------------qzone share ----------------
/**
 @param title 写说说的内容，可以为空
 @param images 发送的多张图片队列
 @code 分享图片/纯文本到QZone,都可以为空

*/
+ (SendResultCode)shareForQZoneTitle:(NSString *)title ImageDataArray:(NSArray *)images;









@end
