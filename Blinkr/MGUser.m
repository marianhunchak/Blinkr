//
//  MGUser.m
//  T
//
//  Created by Admin on 7/18/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGUser.h"
#import "NSDictionary+Accessors.h"
#import "NSString+ValidateValue.h"

@implementation MGUser

+ (instancetype)initWithDict:(NSDictionary*) dict {
    
    MGUser *lUser = [MGUser new];
    
    lUser.id_ = [dict unsignedIntegerForKey:@"id"];
    lUser.name = [NSString validateValue:dict[@"name"]];
    lUser.facebookLink = [NSString validateValue:dict[@"facebook_link"]];
    lUser.email = [NSString validateValue:dict[@"email"]];
    lUser.licensePlate = [NSString validateValue:dict[@"license_plate"]];
    lUser.phoneNumber = [NSString validateValue:dict[@"phone_number"]];
    lUser.rate = [dict floatForKey:@"rate"];
    lUser.teslaModel = [NSString validateValue:dict[@"car_model"]];
    lUser.bio = [NSString validateValue:dict[@"bio"]];

    lUser.showEmail = [dict boolForKey:@"show_email"];
    lUser.showPhoneNumber = [dict boolForKey:@"show_phone_number"];
    lUser.showLicensePlate = [dict boolForKey:@"show_license_plate"];
    lUser.showFacebookLink = [dict boolForKey:@"show_facebook_link"];
    lUser.isRated = [dict boolForKey:@"is_rated_by_current_user"];

    lUser.imageURL = [NSURL URLWithString:[NSString validateValue:dict[@"picture"][@"url"]]];
    lUser.smallImageURL = [NSURL URLWithString:[NSString validateValue:dict[@"picture"][@"small_picture_url"]]];
    
    return lUser;
}

@end
