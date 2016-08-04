//
//  Notification.m
//  Blinkr
//
//  Created by Admin on 8/4/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "Notification.h"
#import "NSDictionary+Accessors.h"

@implementation Notification

+ (void)initWithNotificationDict:(NSDictionary *)dict {
    
    Notification *lOldNotification = [Notification MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"id_ == %@", [dict numberForKey:@"id"]]];
    
    if (lOldNotification) {
        
        lOldNotification.id_ = [dict numberForKey:@"id"];
        lOldNotification.sender_id = [dict[@"sender"] numberForKey:@"id"];
        lOldNotification.senderName = [dict[@"sender"] stringForKey:@"name"];
        lOldNotification.senderPictureURL = [dict[@"sender"] stringForKey:@"picture_url"];
        lOldNotification.title = [dict stringForKey:@"title"];
        lOldNotification.text = [dict stringForKey:@"text"];
        lOldNotification.channel = [dict stringForKey:@"channel"];
        lOldNotification.dateString = [dict stringForKey:@"date"];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
    } else {
        
        Notification *lNotification = [Notification MR_createEntity];
        
        lNotification.id_ = [dict numberForKey:@"id"];
        lNotification.sender_id = [dict[@"sender"] numberForKey:@"id"];
        lNotification.senderName = [dict[@"sender"] stringForKey:@"name"];
        lNotification.senderPictureURL = [dict[@"sender"] stringForKey:@"picture_url"];
        lNotification.title = [dict stringForKey:@"title"];
        lNotification.text = [dict stringForKey:@"text"];
        lNotification.channel = [dict stringForKey:@"channel"];
        lNotification.dateString = [dict stringForKey:@"date"];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
    }
}

+ (void)initWithRecievedNotification:(NSDictionary *)dict {
    
    Notification *lOldNotification = [Notification MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"id_ == %@", [dict numberForKey:@"id"]]];
    
    if (!lOldNotification) {
        
        Notification *lNotification = [Notification MR_createEntity];
        
        lNotification.id_ = [dict numberForKey:@"id"];
        lNotification.sender_id = [dict numberForKey:@"sender_id"];
        lNotification.senderName = [dict stringForKey:@"name"];
        lNotification.senderPictureURL = [dict stringForKey:@"picture_url"];
        lNotification.title = [dict stringForKey:@"title"];
        lNotification.text = [dict[@"aps"] stringForKey:@"alert"];
        lNotification.channel = [dict stringForKey:@"channel"];
        lNotification.dateString = [dict stringForKey:@"date"];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
    }
}


@end
