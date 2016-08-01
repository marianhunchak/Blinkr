//
//  MGChatController.h
//  Blinkr
//
//  Created by Admin on 7/28/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"

@interface MGChatController : JSQMessagesViewController

@property (assign, nonatomic) NSInteger recieverID;
@property (strong, nonatomic) NSString *recieverName;
@property (strong, nonatomic) NSString *channel;

@end
