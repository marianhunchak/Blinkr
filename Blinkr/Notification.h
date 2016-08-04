//
//  Notification.h
//  Blinkr
//
//  Created by Admin on 8/4/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Notification : NSManagedObject

+ (void)initWithNotificationDict:(NSDictionary *)dict;
+ (void)initWithRecievedNotification:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

#import "Notification+CoreDataProperties.h"
