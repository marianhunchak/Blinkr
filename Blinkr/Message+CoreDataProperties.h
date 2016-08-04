//
//  Message+CoreDataProperties.h
//  Blinkr
//
//  Created by Admin on 8/4/16.
//  Copyright © 2016 Midgets. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *pathKey;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *channel;
@property (nullable, nonatomic, retain) NSString *senderId;

@end

NS_ASSUME_NONNULL_END
