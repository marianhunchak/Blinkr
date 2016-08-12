//
//  Profile.h
//  Blinkr
//
//  Created by Admin on 8/10/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Profile : NSManagedObject

+ (void)initWithDict:(NSDictionary *)dict;
+ (void)updateProfileWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

#import "Profile+CoreDataProperties.h"
