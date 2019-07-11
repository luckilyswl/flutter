#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include <fluwx/FluwxResponseHandler.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [super application:app openURL:url options:options];
    }
    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
}

@end
