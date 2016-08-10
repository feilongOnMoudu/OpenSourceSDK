//
//  PushUtil.h
//  PushUtil
//
//  Created by 宋飞龙 on 16/8/10.
//  Copyright © 2016年 宋飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"
#import "XGPush.h"
#import "XGSetting.h"

@interface PushUtil : NSObject

/**
 *  注册设备
 *
 *  @param deviceToken 设备号
 */
+ (void)jPushRegisterDeviceToken:(NSData *)deviceToken;

+ (void)jPushSetAccount:(NSString *)account;

+ (void)jPushUnRegisterDevice;

/**
 *  注册要处理的远程通知类型
 *
 *  @param types 通知类型
 */
+ (void)jPushRegisterForRemoteNotificationTypes;

/**
 *  启动SDK
 *
 *  @param launchingOption 启动参数
 *  @param appKey          一个JPush 应用必须的,唯一的标识. 请参考 JPush 相关说明文档来获取这个标识.
 *  @param channel         发布渠道. 可选.
 */
+ (void)jPushSetupWithOption:(NSDictionary *)launchingOption
                      appKey:(NSString *)appKey
                     channel:(NSString *)channel;

/**
 *  App运行时推送反馈
 *
 *  @param remoteInfo   启动参数
 *  @param successBlock 回调
 */
+ (void)jPushAppRun:(NSDictionary *)remoteInfo
       successBlock:(void (^)(void))successBlock;




/*
 信鸽推送
 */
/**
 *  初始化信鸽
 *
 *  @param launchingOption 启动参数
 *  @param appId           通过前台申请的应用ID
 *  @param appKey          通过前台申请的appKey
 */
+ (void)xgPushSetupWithOption:(NSDictionary *)launchingOption
                        appId:(uint32_t)appId
                       appKey:(NSString *)appKey;

+ (void)xgPushRegisterDeviceToken:(NSData *)deviceToken;

+ (void)xgPushSetAccount:(NSString *)account;

+ (void)xgPushUnRegisterDevice;

//app在杀死状态下点击通知中心回调
+ (void)xgPushAppDie:(NSDictionary *)launchOptions
        successBlock:(void (^)(void))successBlock
          errorBlock:(void (^)(void))errorBlock;

//app在运行中(包括前台、后台)通知回调
+ (void)xgPushAppRun:(NSDictionary*)launchOptions
        successBlock:(void (^)(void))successBlock
          errorBlock:(void (^)(void))errorBlock
          completion:(void (^)(void))completion;

@end
