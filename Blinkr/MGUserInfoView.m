//
//  MGUserInfoView.m
//  Blinkr
//
//  Created by Admin on 8/13/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGUserInfoView.h"
#import "MGUser.h"
#import "MGChatController.h"
#import "MGUserProfileViewController.h"

@interface MGUserInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *userRatingView;
@property (weak, nonatomic) IBOutlet UITextView *userPhoneTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;

@property (strong, nonatomic) MGUser *user;

@end

@implementation MGUserInfoView

+ (instancetype)loadUserInfoView {
    
    NSArray *viewes = [[NSBundle mainBundle] loadNibNamed:@"MGUserInfoView" owner:nil options:nil];
    
    MGUserInfoView *newUserInfoView = [viewes firstObject];
    
    newUserInfoView.userImageView.layer.masksToBounds = YES;
    newUserInfoView.userImageView.layer.cornerRadius = newUserInfoView.userImageView.frame.size.width / 2.f;
    
    newUserInfoView.sendMessageBtn.layer.masksToBounds = YES;
    newUserInfoView.sendMessageBtn.layer.cornerRadius = 5.f;
    newUserInfoView.sendMessageBtn.layer.borderColor = mainAppColor.CGColor;
    newUserInfoView.sendMessageBtn.layer.borderWidth = 2.f;
    
    return newUserInfoView;
}

- (void)setUserID:(NSInteger)userID {
    
    _userID = userID;
    
    __weak typeof(self) weakSelf = self;
    
    [MGNetworkManager getUserWithID:userID withCompletion:^(id object, NSError *error) {
        
        if (!error) {
            
            weakSelf.user = object;
            [weakSelf.userImageView setImageWithURL:weakSelf.user.smallImageURL placeholderImage:[UIImage imageNamed:@"user"]];
            weakSelf.userNameLabel.text = weakSelf.user.name;
            weakSelf.userRatingView.value = weakSelf.user.rate;
            weakSelf.userPhoneTextView.text = weakSelf.user.showPhoneNumber ? weakSelf.user.phoneNumber : @"";
        }
        
    }];
    
}

#pragma mark - Actions

- (IBAction)userBtnPressed:(id)sender {
    
    if (_user) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoViewDelegateUserButtonPresed:)]) {
            [self.delegate userInfoViewDelegateUserButtonPresed:_user];
        }
    } 
}

- (IBAction)sendMessageBtnPressed:(id)sender {
    
    if (_user) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoViewDelegateSendMessageBtnPressed:)]) {
            [self.delegate userInfoViewDelegateSendMessageBtnPressed:_user];
        }
    }
}

@end
