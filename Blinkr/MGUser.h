//
//  MGUser.h
//  T
//
//  Created by Admin on 7/18/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGUser : NSObject

@property (assign, nonatomic) NSUInteger id_;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *facebookLink;
@property (assign, nonatomic) double rate;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *teslaModel;
@property (copy, nonatomic) NSString *licensePlate;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *bio;
@property (assign, nonatomic) BOOL showLicensePlate;
@property (assign, nonatomic) BOOL showEmail;
@property (assign, nonatomic) BOOL showFacebookLink;
@property (assign, nonatomic) BOOL showPhoneNumber;
@property (assign, nonatomic) BOOL isRated;
@property (copy, nonatomic) NSURL* imageURL;
@property (copy, nonatomic) NSURL* smallImageURL;


+ (instancetype)initWithDict:(NSDictionary*) dict;

@end
