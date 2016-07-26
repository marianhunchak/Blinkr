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

static NSString *mainURL = @"http://104.236.251.210/api/v1";

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
                firebaseToken:(NSString *)firebaseToken
                withCompletion:(ObjectCompletionBlock)completionBlock {
    
    NSDictionary *params = @{@"token": facebookToken,
                             @"firebase_token": @"it_is_not_valid_token",
                             @"device_type": @"ios"};
    
    [[MGNetworkManager manager] POST:@"login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"authorization"][@"access_token"] forKey:ACCESS_TOKEN_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"picture"][@"small_picture_url"] forKey:PROFILE_PICTURE_URL];
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

@end
