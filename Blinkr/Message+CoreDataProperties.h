//
//  Message+CoreDataProperties.h
//  Blinkr
//
//  Created by Admin on 8/1/16.
//  Copyright © 2016 Midgets. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *channel;
@property (nullable, nonatomic, retain) NSNumber *id_;
@property (nullable, nonatomic, retain) NSNumber *receiver_id;
@property (nullable, nonatomic, retain) NSNumber *sender_id;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *senderName;
@property (nullable, nonatomic, retain) NSString *senderPictureURL;

@end

NS_ASSUME_NONNULL_END
