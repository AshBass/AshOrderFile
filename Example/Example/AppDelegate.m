//
//  AppDelegate.m
//  Example
//
//  Created by Harry Houdini on 2020/8/22.
//  Copyright © 2020 ParadoxStudio. All rights reserved.
//

#import "AppDelegate.h"
#import <AshOrderFile.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+(void)load {
    
}

- (void)OC_Test {
    
}

void C_Test() {
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self OC_Test];
    C_Test();
    [self OC_Test];
    C_Test();
    [self OC_Test];
    [AshOrderFile exportOrderFileWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"OrderFile.order"]];
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
