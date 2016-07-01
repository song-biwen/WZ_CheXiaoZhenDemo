//
//  AppDelegate.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/27.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "AppDelegate.h"
#import "AppKeFuLib.h"


#define APP_KEY @"6f8103225b6ca0cfec048ecc8702dbce"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*微客服 初始化，请到官方网站申请appkey，网址：http://admin.appkefu.com/AppKeFu/admin/index.php
     开发指南：http://admin.appkefu.com/AppKeFu/tutorial-iOS2.html
     开发者QQ群：48661516
     */
    //步骤一：初始化操作
    [[AppKeFuLib sharedInstance] loginWithAppkey:APP_KEY];
    
    //步骤二：注册离线消息推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
         [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else {
        
         [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
   
    
    return YES;
}


#pragma mark 离线消息推送
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //步骤三：同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
    [[AppKeFuLib sharedInstance] uploadDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"收到推送消息。这里主要起到通知的作用，用户进入应用后，服务器会再次推送即时通讯消息");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送失败，原因：%@",error);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //苹果官方规定除特定应用类型，如：音乐、VOIP类可以在后台运行，其他类型应用均不得在后台运行，所以在程序退到后台要执行logout登出，
    //离线消息通过服务器推送可接收到
    //在程序切换到前台时，执行重新登录，见applicationWillEnterForeground函数中
    //步骤四：
    [[AppKeFuLib sharedInstance] logout];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //步骤五：切换到前台重新登录
    [[AppKeFuLib sharedInstance] loginWithAppkey:APP_KEY];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
