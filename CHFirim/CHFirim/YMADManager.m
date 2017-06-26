//
//  YMADManager.m
//  YMAD
//
//  Created by lichanghong on 6/20/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "YMADManager.h"
#import "UMVideoAd.h"
#import "UMengManager.h"
#import "CHADManager.h"
#import "UMMobClick/MobClick.h"
#import <CHBaseUtil.h>

#define YMAppId @"0c3f589b3ff7ca55"
#define YMAppSEC @"b562824149b05276"

//#    define NSLog(...)

@implementation YMADManager

+ (instancetype)defaultManager
{
    static YMADManager *manager = nil;
    @synchronized (self) {
        if (!manager) {
            manager = [[YMADManager alloc]init];
        }
    }
    return manager;
}

+ (void)startYMAD
{
    [UMVideoAd initAppID:YMAppId appKey:YMAppSEC cacheVideo:YES];
}

static NSTimeInterval interval = 0;
+ (void)loadYunSettings
{
    if (time(NULL)-interval<5*60) {
        return;
    }
    
    [CHADManager getDomainSuccess:^(id content) {
        [MobClick event:@"download_settings"];
        NSDictionary*dic = content;
        NSString *app_url = [dic objectForKey:@"app_url"];
        NSString *contact_us = [dic objectForKey:@"contact_us"];
        NSString *cooperation = [dic objectForKey:@"cooperation"];
        NSString *about_us = [dic objectForKey:@"about_us"];
        NSString *whiteList = [dic objectForKey:@"whiteList"];
        NSString *openAD = [dic objectForKey:@"openAD"];
        
        [[NSUserDefaults standardUserDefaults]setObject:app_url forKey:@"app_url"];
        [[NSUserDefaults standardUserDefaults]setObject:contact_us forKey:@"contact_us"];
        [[NSUserDefaults standardUserDefaults]setObject:cooperation forKey:@"cooperation"];
        [[NSUserDefaults standardUserDefaults]setObject:about_us forKey:@"about_us"];
        [[NSUserDefaults standardUserDefaults]setObject:whiteList forKey:@"whiteList"];
        [[NSUserDefaults standardUserDefaults]setObject:openAD forKey:@"openAD"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        interval = time(NULL);
        
    } failure:^(id err) {
    }];
    
}
static NSTimeInterval interval2 = 0;
+ (void)showADInController:(UIViewController*)VC
{
    if (time(NULL)-interval2<60*60) {
        return;
    }
    //开启非wifi预缓存视频文件
    [UMVideoAd videoDownloadOnUNWifi:YES];
    
    [UMVideoAd videoCloseAlertViewWhenWantExit:NO];
    /*
     isHaveVideoStatue的值目前有两个
     0：有视频可以播放
     1：暂时没有可播放视频
     2：网络状态不好
     */
    /*
     isHaveVideoStatue
     0：there are videos for playing
     1：there are no videos for playing
     2：network error
     */
    long openAD = [[NSUserDefaults standardUserDefaults]integerForKey:@"openAD"];
    if (openAD && openAD ==1)
    {
        [MobClick event:@"ad_can_show" label:@"YES"];
        NSArray *whiteList = [[NSUserDefaults standardUserDefaults]objectForKey:@"whiteList"];
        
        NSString *username0 = [[NSUserDefaults standardUserDefaults]objectForKey:@"login_user_name_0"];
        NSString *username1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"login_user_name_1"];
        NSString *username2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"login_user_name_2"];
        
        if (!username0 ||!username1 ||!username2 || [whiteList containsObject:username0]
            || [whiteList containsObject:username1] || [whiteList containsObject:username2] ) { //!login || whitelist
            NSLog(@"!login || whitelist");
        }
        else
        {
            [UMVideoAd videoHasCanPlayVideo:^(int isHaveVideoStatue){
                NSLog(@"is have video to play：%d",isHaveVideoStatue);
                if (isHaveVideoStatue == 0) {
                    [MobClick event:@"have_video_to_play" label:@"YES"];
                    
                    UMBannerView *bannerView = [UMVideoAd videoBannerPlayerFrame:CGRectMake(0,KScreenHeight-114, VC.view.frame.size.width, 50) videoBannerPlayCloseCallBackBlock:^(BOOL isLegal){
                        NSLog(@"close banner");
                    }];
                    [VC.view addSubview:(id)bannerView];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MobClick event:@"AD_videoPlay" label:@"start"];
                        
                        [UMVideoAd videoPlay:VC videoSuperView:VC.view videoPlayerFrame:CGRectMake(0, 64, VC.view.frame.size.width, (VC.view.frame.size.width)*4/7) videoPlayFinishCallBackBlock:^(BOOL isFinishPlay){
                            if (isFinishPlay) {
                                
                                NSLog(@"finish video play");
                                
                            }else{
                                NSLog(@"video drop out");
                            }
                            [MobClick event:@"AD_videoPlay" label:@"finish"];
                            interval2 = time(NULL);
                            
                        } videoPlayConfigCallBackBlock:^(BOOL isLegal){
                            if (isLegal) {
                                [MobClick event:@"video_play_is_valid" label:@"YES"];
                                
                            }else{
                                [MobClick event:@"video_play_is_valid" label:@"NO"];
                                
                            }
                        }];
                        
                    });
                    
                }
                else
                {
                    [MobClick event:@"have_video_to_play" label:@"NO"];
                }
            }];
        }
    }
}

@end
