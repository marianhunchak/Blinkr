//
//  MGUserInfoView.h
//  Blinkr
//
//  Created by Admin on 8/13/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGUser.h"

@class MGUserInfoView;

@protocol MGUserInfoViewDelegate <NSObject>

- (void)userInfoViewDelegateSendMessageBtnPressed:(MGUser *)user;
- (void)userInfoViewDelegateUserButtonPresed:(MGUser *)user;

@end

@interface MGUserInfoView : UIView

@property (assign, nonatomic) NSInteger userID;
@property (weak, nonatomic) id <MGUserInfoViewDelegate> delegate;

+ (instancetype)loadUserInfoView;

@end
