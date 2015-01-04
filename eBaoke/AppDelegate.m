//
//  AppDelegate.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "AppDelegate.h"
#import "AppContext.h"
#import "KeychainItemWrapper.h"
#import "NSString+MD5Addition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];

    // 生成一个新的UUID
    NSString *uuidStr = [self uuidForKeychina];
    NSLog(@"uuidStr=%@",uuidStr);
    
    // 获取保存的UUID , 为舟:W64H86P59A
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"AccountNumber" accessGroup:@"W64H86P59A.com.vencoo.vencoo01id"];
    NSString *UUID = [wrapper objectForKey:(id)CFBridgingRelease(kSecAttrAccount)];

    if ([UUID isEqualToString:@""] || UUID == nil) {
        // 没有设置UUID
        [wrapper setObject:uuidStr forKey:(id)CFBridgingRelease(kSecAttrAccount)];
    }else {
        // 有设置过UUID
    }
    
    UUID = [wrapper objectForKey:(id)CFBridgingRelease(kSecAttrAccount)];
    NSLog(@"MY UUID=%@",UUID);

    // 保存UUID
    [AppContext setTempContextValueByKey:kUniqueGlobalDeviceIdentifierKey value:UUID];
    
    // 保存UUID的MD5
    [AppContext setTempContextValueByKey:kUniqueAppKey value:[UUID stringFromMD5]];
   
    
    // 保存UUID
    [AppContext setTempContextValueByKey:kUniqueGlobalDeviceIdentifierKey value:UUID];
    
    // 保存UUID的MD5
    [AppContext setTempContextValueByKey:kUniqueAppKey value:[UUID stringFromMD5]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *)uuidForKeychina
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    
    return uuid;
}
@end
