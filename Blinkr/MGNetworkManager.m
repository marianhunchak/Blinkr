//
//  MGNetworkManager.m
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGNetworkManager.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MGUser.h"
#import "Message.h"

static NSString *mainURL = @"http://159.203.188.80/api/v1/";

@implementation MGNetworkManager
#pragma mark - Manager methods

+ (AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:mainURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *token =  [NSString stringWithFormat:@"Token token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    return manager;
}


+ (void)loginWithFacebookToken:(NSString *)facebookToken
                firebaseToken:(NSString *)fiToken
                withCompletion:(ObjectCompletionBlock)completionBlock {
    
    NSString *firebaseToken = [[NSUserDefaults standardUserDefaults] stringForKey:FIREBASE_TOKEN_KEY];
    
    NSDictionary *params = @{@"token": facebookToken,
                             @"firebase_token": firebaseToken,
                             @"device_type": @"ios"};
    
    [[MGNetworkManager manager] POST:@"login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"authorization"][@"access_token"] forKey:ACCESS_TOKEN_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"picture"][@"small_picture_url"] forKey:PROFILE_PICTURE_URL];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"name"] forKey:PROFILE_NAME_KEY];
            [[NSUserDefaults standardUserDefaults] setInteger:[responseObject[@"id"] integerValue] forKey:PROFILE_ID_KEY];
            
            NSLog(@"Picture - %@", [[NSUserDefaults standardUserDefaults] objectForKey:PROFILE_PICTURE_URL]);
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            completionBlock(responseObject, nil);
            NSLog(@"Response object - %@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionBlock(nil, error);
        
        NSLog(@"Error - %@", [error localizedDescription]);
        
    }];
    
}

+ (void)updateMyProfileWithID:(NSInteger)userID
                   parameters:(NSDictionary *)params
               withCompletion:(ObjectCompletionBlock)completionBlock {

    NSString *path = [NSString stringWithFormat:@"users/%ld", (long)userID];
    
    [[MGNetworkManager manager] PUT:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionBlock(nil, error);
        
    }];
    
}

+ (void) searchUsersWithString:(NSString *) searchString
                withCompletion:(ArrayCompletionBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"users?search=%@", searchString];
    
    [[MGNetworkManager manager] GET:path parameters:nil progress:nil
     
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock) {
            
            NSMutableArray *responseArray = [NSMutableArray array];
            
            for (NSDictionary *lUserDict in responseObject) {
                
                [responseArray addObject:[MGUser initWithDict:lUserDict]];
            }
            
            completionBlock(responseArray, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionBlock(nil, error);
        
    }];
    
}

+ (void)updateCurrentUserLocationWithLatitude:(double)latitude
                                    longitude:(double)longitude
                               withCompletion:(ObjectCompletionBlock)completionBlock {
    
    NSDictionary *params = @{@"latitude": @(latitude),
                             @"longitude": @(longitude)};
    
    [[MGNetworkManager manager] POST:@"update_location" parameters:params progress:nil
     
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSLog(@"Response object - %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSLog(@"Error - %@", [error localizedDescription]);
        
    }];
    
}

+ (void)getNearestUsersWithRadius:(NSInteger)radius withCompletion:(ArrayCompletionBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"near_users?radius=%lu", (long)radius];
    
    [[MGNetworkManager manager] GET:path parameters:nil progress:nil
     
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock) {
            
            NSLog(@"Response object - %@", responseObject);
            
//            NSMutableArray *responseArray = [NSMutableArray array];
//            
//            for (NSDictionary *lUserDict in responseObject) {
//                
//                [responseArray addObject:[MGUser initWithDict:lUserDict]];
//            }
            
            completionBlock(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionBlock(nil, error);
        
    }];
}

+ (void)sendMessangerNotificationWihtParams:(NSDictionary *)params
                             withCompletion:(ObjectCompletionBlock)completionBlock {

    [[MGNetworkManager manager] POST:@"messenger_notification" parameters:params progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object - %@", responseObject);
             
             completionBlock(responseObject, nil);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             NSLog(@"Error - %@", [error localizedDescription]);
             completionBlock(nil, error);
             
    }];
}

+ (void)getAllNotificationsWithCompletion:(ArrayCompletionBlock)completionBlock {
    
    [[MGNetworkManager manager] GET:@"notifications" parameters:nil progress:nil
     
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (completionBlock) {
                
                NSMutableArray *responseArray = [NSMutableArray array];
                
                for (NSDictionary *lnotifDict in responseObject) {
                    
                    [responseArray addObject:[Message initWithNotificationDict:lnotifDict]];
                }
                
                completionBlock(responseArray, nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            completionBlock(nil, error);
            
    }];
    
}

+ (void)refreshFirebaseToken:(NSString *) firebaseToken
             withCompletion:(ObjectCompletionBlock)completionBlock {
    
    NSDictionary *params = @{@"firebase_token": firebaseToken};
    
    [[MGNetworkManager manager] POST:@"refresh_firebase_token" parameters:params progress:nil
     
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
                                 NSLog(@"Response object - %@", responseObject);
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 
                                 
                                 NSLog(@"Error - %@", [error localizedDescription]);
                                 
                             }];
    
}


@end
