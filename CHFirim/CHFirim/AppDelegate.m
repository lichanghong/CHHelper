//
//  AppDelegate.m
//  CHFirim
//
//  Created by lichanghong on 6/8/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "AppDelegate.h"
#import "UMengManager.h"
#import <CHQQShare.h>
#import "YMADManager.h"
#import "CHWXShare.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

//APP ID  1106150891  APP KEYRiZLzvIoue87pOS2
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UMengManager startUmeng];
    [CHWXShare wxRegisterAPP:@"wx39bfcf22391c6fc9"];
    [CHQQShare registerWithAppid:@"1106150891"];
    [YMADManager startYMAD];
    
    [YMADManager loadYunSettings];
 
    return YES;
}


- (NSString *)localFile
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentDir stringByAppendingPathComponent:@"html.html"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [CHWXShare chHandleOpenURL:url delegate:[CHWXShare defaultShare]];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    return [CHWXShare chHandleOpenURL:url delegate:[CHWXShare defaultShare]];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [CHWXShare chHandleOpenURL:url delegate:[CHWXShare defaultShare]];
}

 


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
