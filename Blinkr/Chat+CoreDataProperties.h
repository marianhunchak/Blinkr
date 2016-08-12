//
//  Chat+CoreDataProperties.h
//  Blinkr
//
//  Created by Admin on 8/12/16.
//  Copyright © 2016 Midgets. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chat.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chat (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *channel;
@property (nullable, nonatomic, retain) NSString *chatImageURL;
@property (nullable, nonatomic, retain) NSString *chatName;
@property (nullable, nonatomic, retain) id messagesArray;
@property (nullable, nonatomic, retain) NSNumber *receiverId;
@property (nullable, nonatomic, retain) NSNumber *receiverRate;
@property (nullable, nonatomic, retain) NSString *lastMessageDate;

@end

NS_ASSUME_NONNULL_END
