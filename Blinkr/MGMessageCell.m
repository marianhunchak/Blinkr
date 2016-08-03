//
//  MGMessageCell.m
//  Blinkr
//
//  Created by Admin on 7/28/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGMessageCell.h"
#import "JSQMessagesTimestampFormatter.h"
@import Firebase;

@implementation MGMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2.0;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 1.f;
    self.userImageView.layer.borderColor = mainAppColor.CGColor;
}

- (void)setChannel:(NSString *)channel {
    _channel = channel;
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *chatRef = [ref child:channel];
    FIRDatabaseQuery *messagesQuery = [chatRef queryLimitedToLast:1];
    
    [messagesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        _messageLabel.text = snapshot.value[@"message"];
//        _userNameLabel.text = snapshot.value[@"author"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSSZZZ"];
        
        NSDate *date = [dateFormatter dateFromString:snapshot.value[@"date"]];
        
        if (date) {
            _timeLabel.text = [[[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:date] string];
        }
        
    }];
    
}


@end
