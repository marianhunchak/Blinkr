//
//  Message.m
//  Blinkr
//
//  Created by Admin on 8/1/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "Message.h"
#import "NSDictionary+Accessors.h"

@implementation Message

+ (instancetype)initWithNotificationDict:(NSDictionary *)dict {
    
    Message *lMessage = [Message MR_createEntity];
    
    lMessage.id_ = [dict numberForKey:@"id"];
    lMessage.sender_id = [dict[@"sender"] numberForKey:@"id"];
    lMessage.senderName = [dict[@"sender"] stringForKey:@"name"];
    lMessage.senderPictureURL = [dict[@"sender"] stringForKey:@"picture_url"];
    lMessage.receiver_id = [dict numberForKey:@"receiver_id"];
    lMessage.title = [dict stringForKey:@"title"];
    lMessage.text = [dict stringForKey:@"text"];
    lMessage.channel = [dict stringForKey:@"channel"];
    
    return lMessage;
}

@end
