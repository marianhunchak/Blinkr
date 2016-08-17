//
//  Profile.m
//  Blinkr
//
//  Created by Admin on 8/10/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "Profile.h"
#import "NSDictionary+Accessors.h"

@implementation Profile

+ (void)initWithDict:(NSDictionary *)dict {
    
    Profile *lProfile = [Profile MR_findFirst];
    
    if (!lProfile) {
        lProfile = [Profile MR_createEntity];
    }
    
    lProfile.id_ = [dict numberForKey:@"id"];
    lProfile.name = [dict stringForKey:@"name"];
    lProfile.facebook_link = [dict stringForKey:@"facebook_link"];
    lProfile.email = [dict stringForKey:@"email"];
    lProfile.license_plate = [dict stringForKey:@"license_plate"];
    lProfile.phone_number = [dict stringForKey:@"phone_number"];
    lProfile.rate = [dict numberForKey:@"rate"];
    lProfile.car_model = [dict stringForKey:@"car_model"];
    lProfile.bio = [dict stringForKey:@"bio"];
    lProfile.pictureURL = [dict[@"picture"] stringForKey:@"url"];
    lProfile.access_token = [dict[@"authorization"] stringForKey:@"access_token"];
    lProfile.show_email = [dict numberForKey:@"show_email"];
    lProfile.show_facebook_link = [dict numberForKey:@"show_facebook_link"];
    lProfile.show_license_plate = [dict numberForKey:@"show_license_plate"];
    lProfile.show_phone_number = [dict numberForKey:@"show_phone_number"];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}

+ (void)updateProfileWithDict:(NSDictionary *)dict {
    
    Profile *lProfile = [Profile MR_findFirst];
    
    lProfile.name = [dict stringForKey:@"name"];
    lProfile.email = [dict stringForKey:@"email"];
    lProfile.license_plate = [dict stringForKey:@"license_plate"];
    lProfile.phone_number = [dict stringForKey:@"phone_number"];
    lProfile.car_model = [dict stringForKey:@"car_model"];
    lProfile.bio = [dict stringForKey:@"bio"];
    lProfile.show_email = [dict numberForKey:@"show_email"];
    lProfile.show_facebook_link = [dict numberForKey:@"show_facebook_link"];
    lProfile.show_license_plate = [dict numberForKey:@"show_license_plate"];
    lProfile.show_phone_number = [dict numberForKey:@"show_phone_number"];
    
    
}

@end
