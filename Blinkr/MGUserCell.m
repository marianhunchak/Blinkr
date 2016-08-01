//
//  MGUserCell.m
//  Blinkr
//
//  Created by Admin on 7/26/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGUserCell.h"
#import "HCSStarRatingView.h"
#import "UIImageView+AFNetworking.h"

@interface MGUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rateView;
@property (weak, nonatomic) IBOutlet UITextView *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

@end

@implementation MGUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 1.f;
    self.userImageView.layer.borderColor = mainAppColor.CGColor;
    
    self.sendMessageButton.layer.cornerRadius = 5.f;
    self.sendMessageButton.layer.masksToBounds = YES;
    self.sendMessageButton.layer.borderWidth = 1.f;
    self.sendMessageButton.layer.borderColor = mainAppColor.CGColor;
}

- (void)setUser:(MGUser *)user {
    
    _user = user;
    
    [_userImageView setImageWithURL:user.smallImageURL placeholderImage:[UIImage imageNamed:@"user"]];
    
    _nameLabel.text = user.name;
    
    _rateView.value = user.rate;
    
    _phoneTextField.text = user.showPhoneNumber ? user.phoneNumber : @"";
    
}

- (IBAction)sendMessageBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCellDelegateSendMessageBtnPressed:)]) {
        [self.delegate userCellDelegateSendMessageBtnPressed:self];
    }
    
}

@end
