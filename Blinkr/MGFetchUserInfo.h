//
//  MGFetchUserInfo.h
//  S3XTesla
//
//  Created by Орест on 31.05.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGFetchUserInfo : NSObject

@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *facebookLink;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *licensePlate;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *bio;
@property (assign, nonatomic) double rate;
@property (assign, nonatomic) BOOL showEmail;
@property (assign, nonatomic) BOOL showFacebookLink;
@property (assign, nonatomic) BOOL showLicensePlate;
@property (assign, nonatomic) BOOL showPhoneNumber;
@property (strong, nonatomic) NSString *teslaModel;
@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) NSString *userToken;

- (id) initWithServerRespons:(NSDictionary*) responsObject;

@end
