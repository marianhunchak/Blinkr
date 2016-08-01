//
//  MGChannelUtil.h
//  Blinkr
//
//  Created by Admin on 8/1/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGChannelUtil : NSObject

+ (NSString *)getChannelWithSenderId:(NSInteger)pSenderId recieverId:(NSInteger)pRecieverId;

@end
