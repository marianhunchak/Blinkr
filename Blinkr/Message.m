//
//  Message.m
//  Blinkr
//
//  Created by Admin on 8/3/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "Message.h"
#import "NSDictionary+Accessors.h"

@implementation Message

+ (void)initWithNotificationDict:(NSDictionary *)dict {

    Message *lOldMessage = [Message MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel == %@ AND dateString == %@",[dict stringForKey:@"channel"], [dict stringForKey:@"date"]]];
    
    if (lOldMessage) {
        
        lOldMessage.id_ = [dict numberForKey:@"id"];
        lOldMessage.sender_id = [dict[@"sender"] numberForKey:@"id"];
        lOldMessage.senderName = [dict[@"sender"] stringForKey:@"name"];
        lOldMessage.senderPictureURL = [dict[@"sender"] stringForKey:@"picture_url"];
        lOldMessage.title = [dict stringForKey:@"title"];
        lOldMessage.text = [dict stringForKey:@"text"];
        lOldMessage.channel = [dict stringForKey:@"channel"];
        lOldMessage.dateString = [dict stringForKey:@"date"];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
    } else {
        
        Message *lMessage = [Message MR_createEntity];
        
        lMessage.id_ = [dict numberForKey:@"id"];
        lMessage.sender_id = [dict[@"sender"] numberForKey:@"id"];
        lMessage.senderName = [dict[@"sender"] stringForKey:@"name"];
        lMessage.senderPictureURL = [dict[@"sender"] stringForKey:@"picture_url"];
        lMessage.title = [dict stringForKey:@"title"];
        lMessage.text = [dict stringForKey:@"text"];
        lMessage.channel = [dict stringForKey:@"channel"];
        lMessage.dateString = [dict stringForKey:@"date"];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

    }
}

+ (void)initWithRecievedNotification:(NSDictionary *)dict {
    
    Message *lOldMessage = [Message MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel == %@ AND dateString == %@",[dict stringForKey:@"channel"], [dict stringForKey:@"date"]]];
    
    if (!lOldMessage) {
        
        Message *lMessage = [Message MR_createEntity];
        
        lMessage.id_ = [dict numberForKey:@"id"];
        lMessage.sender_id = [dict[@"sender"] numberForKey:@"id"];
        lMessage.senderName = [dict[@"sender"] stringForKey:@"name"];
        lMessage.senderPictureURL = [dict[@"sender"] stringForKey:@"picture_url"];
        lMessage.title = [dict stringForKey:@"title"];
        lMessage.text = [dict[@"aps"] stringForKey:@"alert"];
        lMessage.channel = [dict stringForKey:@"channel"];
        lMessage.dateString = [dict stringForKey:@"date"];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
    }
}

@end
