//
//  MGUserProfileViewController.h
//  T
//
//  Created by Орест on 22.06.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGUser;

@interface MGUserProfileViewController : UITableViewController

@property (strong, nonatomic) MGUser *user;
@property (assign, nonatomic) NSUInteger userId;

@end
