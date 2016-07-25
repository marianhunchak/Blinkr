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

@end
