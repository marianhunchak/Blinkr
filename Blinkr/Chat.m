//
//  Chat.m
//  Blinkr
//
//  Created by Admin on 7/29/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "Chat.h"
#import <MagicalRecord/MagicalRecord.h>
#import "NSDictionary+Accessors.h"

@implementation Chat

@dynamic id_;
@dynamic receiver_id;
@dynamic sender_id;
@dynamic title;
@dynamic text;
@dynamic channel;

+ (instancetype)initWithNotificationDict:(NSDictionary *)dict {
    
    Chat *chat = [Chat MR_createEntity];
    
    chat.id_ = [dict numberForKey:@"id"];
    chat.sender_id = [dict numberForKey:@"sender_id"];
    chat.receiver_id = [dict numberForKey:@"receiver_id"];
    chat.title = [dict stringForKey:@"title"];
    chat.text = [dict stringForKey:@"text"];
    chat.channel = [dict stringForKey:@"channel"];
    
    return chat;
}

//+ (instancetype)initWithFirebaseDict:(NSDictionary *)dict {
//    
//    Chat *chat = [Chat MR_createEntity];
//    
//    chat.id_ = [dict numberForKey:@"id"];
//    chat.sender_id = [dict numberForKey:@"sender_id"];
//    chat.receiver_id = [dict numberForKey:@"receiver_id"];
//    chat.title = [dict stringForKey:@"title"];
//    chat.text = [dict stringForKey:@"text"];
//    chat.channel = [dict stringForKey:@"channel"];
//    
//    return chat;
//}

@end
