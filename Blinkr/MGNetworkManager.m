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

static NSString *mainURL = @"http://104.236.251.210/api/v1";

@implementation MGNetworkManager
#pragma mark - Manager methods

+ (AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:mainURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authentication-Token"];

    return manager;
}


+ (void)loginWithFacebookToken:(NSString *)facebookToken
                firebaseToken:(NSString *)firebaseToken
                withCompletion:(ObjectCompletionBlock)completionBlock {
    
    NSDictionary *params = @{@"token": facebookToken,
                             @"firebase_token": @"it_is_not_valid_token",
                             @"device_type": @"ios" };
    
    [[MGNetworkManager manager] POST:@"login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"authorization"][@"access_token"] forKey:ACCESS_TOKEN_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"picture"][@"small_picture_url"] forKey:PROFILE_PICTURE_URL];
            
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


@end
