//
//  MGEditMyProfileViewController.h
//  S3XTesla
//
//  Created by Орест on 01.06.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGFetchUserInfo;

@interface MGEditMyProfileViewController : UITableViewController

@property (strong, nonatomic) MGFetchUserInfo *userInfo;
@property (strong, nonatomic) UIImage *userImage;

@end
