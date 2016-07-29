//
//  Chat.h
//  Blinkr
//
//  Created by Admin on 7/29/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Chat : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *id_;
@property (nullable, nonatomic, retain) NSNumber *receiver_id;
@property (nullable, nonatomic, retain) NSNumber *sender_id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *channel;

+ (instancetype)initWithNotificationDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

