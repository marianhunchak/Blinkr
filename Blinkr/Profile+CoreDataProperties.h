//
//  Profile+CoreDataProperties.h
//  Blinkr
//
//  Created by Admin on 8/10/16.
//  Copyright © 2016 Midgets. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Profile.h"

NS_ASSUME_NONNULL_BEGIN

@interface Profile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id_;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *facebook_link;
@property (nullable, nonatomic, retain) NSNumber *rate;
@property (nullable, nonatomic, retain) NSString *phone_number;
@property (nullable, nonatomic, retain) NSString *car_model;
@property (nullable, nonatomic, retain) NSString *license_plate;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *pictureURL;
@property (nullable, nonatomic, retain) NSString *access_token;
@property (nullable, nonatomic, retain) NSNumber *show_email;
@property (nullable, nonatomic, retain) NSNumber *show_facebook_link;
@property (nullable, nonatomic, retain) NSNumber *show_license_plate;
@property (nullable, nonatomic, retain) NSNumber *show_phone_number;
@property (nullable, nonatomic, retain) NSString *bio;

@end

NS_ASSUME_NONNULL_END
