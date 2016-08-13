//
//  MGNetworkManager.h
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"

@interface MGNetworkManager : NSObject

+ (void)loginWithFacebookToken:(NSString *)facebookToken
                 firebaseToken:(NSString *)firebaseToken
                withCompletion:(ObjectCompletionBlock)completionBlock;

+ (void)logOutWithCompletion:(ObjectCompletionBlock)completionBlock;

+ (void)updateMyProfileWithID:(NSInteger)userID
                   parameters:(NSDictionary *)params
               withCompletion:(ObjectCompletionBlock)completionBlock;

+ (void)searchUsersWithString:(NSString *) searchString
                withCompletion:(ArrayCompletionBlock)completionBlock;

+ (void)getUserWithID:(NSInteger)userId withCompletion:(ObjectCompletionBlock)completionBlock;

+ (void)rateUserWithParams:(NSDictionary *)params completion:(ObjectCompletionBlock)completionBlock;

+ (void)updateCurrentUserLocationWithLatitude:(double)latitude
                                    longitude:(double)longitude
                               withCompletion:(ObjectCompletionBlock)completionBlock;

+ (void)clearCurrenUserLocation;

+ (void)getNearestUsersWithRadius:(NSInteger)radius withCompletion:(ArrayCompletionBlock)completionBlock;

+ (void)sendMessangerNotificationWihtParams:(NSDictionary *)params
                             withCompletion:(ObjectCompletionBlock)completionBlock;

+ (void)getAllNotificationsWithCompletion:(ArrayCompletionBlock)completionBlock;

+ (void)refreshFirebaseToken:(NSString *) firebaseToken
              withCompletion:(ObjectCompletionBlock)completionBlock;

+ (NSURLSessionDataTask *)deleteNotificationWithID:(NSInteger) notificationID
                                    withCompletion:(ObjectCompletionBlock)completionBlock;

@end
