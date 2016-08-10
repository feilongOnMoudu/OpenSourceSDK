//
//  PushUtil.m
//  PushUtil
//
//  Created by 宋飞龙 on 16/8/10.
//  Copyright © 2016年 宋飞龙. All rights reserved.
//

#import "PushUtil.h"
#import <UIKit/UIKit.h>

@implementation PushUtil

+ (void)jPushRegisterDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

+ (void)jPushRegisterForRemoteNotificationTypes {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert) categories:nil];
#pragma clang diagnostic pop
}

+ (void)jPushSetupWithOption:(NSDictionary *)launchingOption
                      appKey:(NSString *)appKey
                     channel:(NSString *)channel {
#ifdef DEBUG
    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:NO];
#endif
    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:YES];
}

+ (void)jPushAppRun:(NSDictionary *)remoteInfo
       successBlock:(void (^)(void))successBlock {
    [JPUSHService handleRemoteNotification:remoteInfo];
}

+ (void)jPushSetAccount:(NSString *)account {
    [JPUSHService setTags:[NSSet set] aliasInbackground:account];
}

+ (void)jPushUnRegisterDevice {
    [JPUSHService setAlias:@"" callbackSelector:nil object:self];
}










+ (void)xgPushSetupWithOption:(NSDictionary *)launchingOption
                        appId:(uint32_t)appId
                       appKey:(NSString *)appKey {
    [XGPush startApp:appId appKey:appKey];
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus]) {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8) {
                [PushUtil registerPush];
            } else {
                [PushUtil registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [PushUtil registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
}

+ (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

+ (void)registerPush{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    
}

+ (void)xgPushRegisterDeviceToken:(NSData *)deviceToken {
    [XGPush registerDevice:deviceToken];
}

+ (void)xgPushSetAccount:(NSString *)account {
    [XGPush setAccount:account];
}

+ (void)xgPushUnRegisterDevice {
    [XGPush unRegisterDevice];
}

+ (void)xgPushAppDie:(NSDictionary *)launchOptions
        successBlock:(void (^)(void))successBlock
          errorBlock:(void (^)(void))errorBlock {
    //推送反馈(app不在前台运行时，点击推送激活时)
    [XGPush handleLaunching:launchOptions];
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}

//app在运行中(包括前台、后台)通知回调
+ (void)xgPushAppRun:(NSDictionary*)launchOptions
        successBlock:(void (^)(void))successBlock
          errorBlock:(void (^)(void))errorBlock
          completion:(void (^)(void))completion{
    [XGPush handleReceiveNotification:launchOptions];
    [XGPush handleReceiveNotification:launchOptions successCallback:successBlock errorCallback:errorBlock completion:completion];
}


@end
