//
//  AppDelegate.m
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+ShorthandMethods.h>
#import "NSDictionary+Accessors.h"
#import "SignInController.h"
#import "MGTabBarController.h"
#import "MGMessagesController.h"

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [MagicalRecord enableShorthandMethods];
    [MagicalRecord setupCoreDataStack];

    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UITabBar appearance] setTintColor: RGBHColor(0xFF6600)];
    
    // configure notifications
    
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // [START configure_firebase]
    
    [FIRApp configure];
    [FIRDatabase database].persistenceEnabled = YES;
    // [END configure_firebase]
    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    if (launchOptions != nil) {
        // Launched from push notification
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

        Notification *lNotification = [Notification initWithRecievedNotification:notification];
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        // Create a nav/vc pair using the custom ViewController class
        
        UINavigationController *navigationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"navigationController"];
//        navigationVC.navigationBar.tintColor = UIColor.whiteColor()
        SignInController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInController"];
        
        // Push the vc onto the nav
        [navigationVC setViewControllers:@[vc] animated:NO];
        // Set the window’s root view controller
        self.window.rootViewController = navigationVC;
        
        MGTabBarController *tabBar = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MGTabBarController"];
        
        [navigationVC pushViewController:tabBar animated:NO];
        
        // Present the window
        [self.window makeKeyAndVisible];
        
        [tabBar.delegate tabBarController:tabBar shouldSelectViewController:[[tabBar viewControllers] objectAtIndex:2]];
        [tabBar setSelectedIndex:2];
    }
    
    
    return YES;
}


// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    Notification *lNotification = [Notification initWithRecievedNotification:userInfo];
    
    // Print message ID.
    
    if (application.applicationState == UIApplicationStateInactive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapped_on_notification" object:lNotification];
    }
    
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: [userInfo[@"aps"] integerForKey:@"badge"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_received" object:nil];
    
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// With "FirebaseAppDelegateProxyEnabled": NO
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    
//    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
//    
//    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
//    
//    if (refreshedToken != nil ) {
//        
//        [[NSUserDefaults standardUserDefaults] setObject:refreshedToken forKey:FIREBASE_TOKEN_KEY];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//
//}

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    
    if (refreshedToken != nil ) {
        
        [[NSUserDefaults standardUserDefaults] setObject:refreshedToken forKey:FIREBASE_TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [MGNetworkManager refreshFirebaseToken:refreshedToken withCompletion:^(id object, NSError *error) {
            
        }];
        
    }

    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    // TODO: If necessary send token to appliation server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
     [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [MGNetworkManager clearCurrenUserLocation];
}

@end
