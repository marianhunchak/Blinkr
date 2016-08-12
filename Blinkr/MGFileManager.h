//
//  MGFileManager.h
//  Blinkr
//
//  Created by Admin on 8/10/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGFileManager : NSObject

+ (NSString *)writeProfileImageToDocuments:(UIImage *)image;
+ (UIImage *)getProfileImageFromDocuments;

@end
