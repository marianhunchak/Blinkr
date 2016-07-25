//
//  MGFetchUserInfo.m
//  S3XTesla
//
//  Created by Орест on 31.05.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGFetchUserInfo.h"
#import "NSDictionary+Accessors.h"
#import "NSString+ValidateValue.h"

@implementation MGFetchUserInfo

- (id) initWithServerRespons:(NSDictionary*) responsObject
{
    self = [super init];
    if (self) {
        
        self.name = [NSString validateValue:responsObject[@"name"]];
        self.facebookLink = [NSString validateValue:responsObject[@"facebook_link"]];
        self.email = [NSString validateValue:responsObject[@"email"]];
        self.licensePlate = [NSString validateValue:responsObject[@"license_plate"]];
        self.phoneNumber = [NSString validateValue:responsObject[@"phone_number"]];
        self.rate = [responsObject floatForKey:@"rate"];
        self.teslaModel = [NSString validateValue:responsObject[@"tesla_model"]];
        self.bio = [NSString validateValue:responsObject[@"bio"]];
        self.userID = [responsObject integerForKey:@"id"];
        self.userToken = responsObject[@"authorization"][@"access_token"];
        self.showEmail = [responsObject boolForKey:@"show_email"];
        self.showPhoneNumber = [responsObject boolForKey:@"show_phone_number"];
        self.showLicensePlate = [responsObject boolForKey:@"show_license_plate"];
        self.showFacebookLink = [responsObject boolForKey:@"show_facebook_link"];
        
//        [[NSUserDefaults standardUserDefaults] setInteger:self.userID forKey:USER_ID];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString* urlString = [NSString validateValue:responsObject[@"picture"][@"url"]];
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
    }
    return self;
}

@end
