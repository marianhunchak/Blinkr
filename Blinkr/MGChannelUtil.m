//
//  MGChannelUtil.m
//  Blinkr
//
//  Created by Admin on 8/1/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGChannelUtil.h"

@implementation MGChannelUtil

+ (NSString *)getChannelWithSenderId:(NSInteger)pSenderId recieverId:(NSInteger)pRecieverId {
    
    
    NSString *channelString = nil;
    
    if (pSenderId < pRecieverId) {
        
        channelString = [NSString stringWithFormat:@"%ld_%ld", pSenderId, pRecieverId];
        
    } else {
        
        channelString = [NSString stringWithFormat:@"%ld_%ld", pRecieverId, pSenderId];
    }
    
    return channelString;
    
}

@end
