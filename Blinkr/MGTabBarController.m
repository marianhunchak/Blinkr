//
//  MGTabBarController.m
//  Blinkr
//
//  Created by Admin on 8/4/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGTabBarController.h"

@interface MGTabBarController ()

@end

@implementation MGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived) name:@"notification_received" object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    
    [self setBadgeValueForTabBarItem];
    
    [MGNetworkManager getAllNotificationsWithCompletion:^(NSArray *array, NSError *error) {
        
        [weakSelf setBadgeValueForTabBarItem];
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications

- (void) notificationReceived {
    
    [self setBadgeValueForTabBarItem];
    
}

- (void) setBadgeValueForTabBarItem {
    
    NSArray *lNotificationsArray = [Notification MR_findAll];
    NSString *badgeValue = [lNotificationsArray count] > 0 ? [NSString stringWithFormat:@"%ld", [lNotificationsArray count]] : nil;
    [[self.tabBar.items objectAtIndex:2] setBadgeValue:badgeValue];
}


@end
