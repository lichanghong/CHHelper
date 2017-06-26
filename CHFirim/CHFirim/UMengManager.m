//
//  UMengManager.m
//  CHFirim
//
//  Created by lichanghong on 6/14/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "UMengManager.h"
#import "UMMobClick/MobClick.h"
#import "Constants.h"
 

@implementation UMengManager


+ (instancetype)defaultManager
{
    static UMengManager *manager = nil;
    @synchronized (self) {
        if (!manager) {
            manager = [[UMengManager alloc]init];
        }
    }
    return manager;
}

+ (void)startUmeng
{
    UMConfigInstance.appKey = Firim_iphone_key;

    UMConfigInstance.channelId = Firim_iphone_ChannelId;
#ifdef DEBUG
    UMConfigInstance.ePolicy = REALTIME;

#endif
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    BOOL logined = NO;
    for (int i=0; i<4;i++) {
       logined = [[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"LOGINED_%lu",(unsigned long)i]];
        if (logined) {
            break;
        }
    }

    if (logined) {
        NSString *username0 = [[NSUserDefaults standardUserDefaults]objectForKey:@"login_user_name_0"];
        NSString *username1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"login_user_name_1"];
        NSString *username2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"login_user_name_2"];
        NSString *username3 = [[NSUserDefaults standardUserDefaults]objectForKey:@"login_user_name_3"];
        NSString *username = [NSString stringWithFormat:@"%@_%@_%@_%@",username0,username1,username2,username3];
        [MobClick profileSignInWithPUID:username];
    }
    [MobClick setEncryptEnabled:YES];
 
}

 



+ (void)logout
{
    [MobClick profileSignOff];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LOGINED_0"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LOGINED_1"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LOGINED_2"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LOGINED_3"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}











@end
