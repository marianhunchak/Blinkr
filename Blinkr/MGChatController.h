//
//  MGChatController.h
//  Blinkr
//
//  Created by Admin on 7/28/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"
#import "MGUser.h"

@interface MGChatController : JSQMessagesViewController

@property (strong, nonatomic) NSString *channel;
@property (assign, nonatomic) NSInteger receiverId;
@property (strong, nonatomic) NSString *chatName;
@property (strong, nonatomic) NSString *chatImageURL;
@property (strong, nonatomic) MGUser *receiverUser;

- (void)deleteNotficationWhithChannel:(NSString *)pChannel;

@end
