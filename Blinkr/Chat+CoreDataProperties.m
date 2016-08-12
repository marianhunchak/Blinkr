//
//  Chat+CoreDataProperties.m
//  Blinkr
//
//  Created by Admin on 8/12/16.
//  Copyright © 2016 Midgets. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chat+CoreDataProperties.h"

@implementation Chat (CoreDataProperties)

@dynamic channel;
@dynamic chatImageURL;
@dynamic chatName;
@dynamic messagesArray;
@dynamic receiverId;
@dynamic receiverRate;
@dynamic lastMessageDate;

@end
