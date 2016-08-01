//
//  Message.h
//  Blinkr
//
//  Created by Admin on 8/1/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSManagedObject

+ (instancetype)initWithNotificationDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

#import "Message+CoreDataProperties.h"
