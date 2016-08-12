//
//  MGFileManager.m
//  Blinkr
//
//  Created by Admin on 8/10/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGFileManager.h"

static NSString *profileImageName = @"profileImage.jpg";

@implementation MGFileManager

+ (NSString *)writeProfileImageToDocuments:(UIImage *)image {

    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:profileImageName];
    [data writeToURL:documentsURL atomically:YES];
    
    return profileImageName;
}

+ (UIImage *)getProfileImageFromDocuments {

    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *workSpacePath = [documentsDirectory stringByAppendingPathComponent:profileImageName];

    return [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
}

@end
