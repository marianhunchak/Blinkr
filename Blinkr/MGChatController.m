//
//  MGChatController.m
//  Blinkr
//
//  Created by Admin on 7/28/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGChatController.h"
#import "JSQMessages.h"
#import "MGNetworkManager.h"
#import "MGChannelUtil.h"
#import "Chat.h"
#import "Message.h"
#import "UIImageView+AFNetworking.h"
#import "MGUserProfileViewController.h"
@import Firebase;

@interface MGChatController ()

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) UIImageView *receiverImageView;

@end

@implementation MGChatController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    
    self.ref = [[FIRDatabase database] reference];
    
//    self.showLoadEarlierMessagesHeader = YES;
    
    _messages = [NSMutableArray array];
    
    self.senderId = [NSString stringWithFormat:@"%ld", [[NSUserDefaults standardUserDefaults] integerForKey:PROFILE_ID_KEY]];
    self.senderDisplayName = [[NSUserDefaults standardUserDefaults] stringForKey:PROFILE_NAME_KEY];
    if (self.channel == nil) {
        self.channel = [MGChannelUtil getChannelWithSenderId:[self.senderId integerValue] recieverId:_receiverId ? _receiverId : _receiverUser.id_];
    }
    
    [self setupBubbles];
    
    // No avatars
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    [self observeMessages];
    
    
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.chatName ? self.chatName : self.receiverUser.name;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self
               action:@selector(receiverBtnPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];

    button.frame = CGRectMake(0, 0, 40, 40);
    
    button.layer.cornerRadius = button.frame.size.height / 2.0;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = mainAppColor.CGColor;
    
    _receiverImageView = [[UIImageView alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_receiverUser.smallImageURL ? _receiverUser.smallImageURL : [NSURL URLWithString:_chatImageURL]];
    
    UIBarButtonItem *recieverBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = recieverBtn;
    
    [_receiverImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"user"]
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           [button setImage:image forState:UIControlStateNormal];
                                           
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                       }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions 

- (void)receiverBtnPressed {
    
    MGUserProfileViewController *vc = VIEW_CONTROLLER(@"MGUserProfileViewController");
    vc.userId = _receiverId ? _receiverId : _receiverUser.id_;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private methods

- (void) setupBubbles {
    
    JSQMessagesBubbleImageFactory *factory = [JSQMessagesBubbleImageFactory new];
    _outgoingBubbleImageView = [factory outgoingMessagesBubbleImageWithColor:mainAppColor];
    _incomingBubbleImageView = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
}

- (void) addMessageWithSenderID:(NSString *) senderID text:(NSString *) text senderName:(NSString *) name dateString:(NSString *) dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSSZZZ"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderID senderDisplayName:name date:date text:text];
    [_messages addObject:message];
    
}

- (void) observeMessages {
    // 1
    
    FIRDatabaseReference *chatRef = [_ref child:_channel];
    FIRDatabaseQuery *messagesQuery = [chatRef queryLimitedToLast:25];
    
    [messagesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        [self addMessageWithSenderID:snapshot.value[@"senderId"] text:snapshot.value[@"message"] senderName:snapshot.value[@"author"] dateString:snapshot.value[@"date"]];
        
        [self finishReceivingMessage];
        
        Message *lMessage = [Message MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel = %@ AND dateString = %@", _channel, snapshot.value[@"date"]]];
        
        if (lMessage) {
            [MGNetworkManager deleteNotificationWithID:lMessage.id_.integerValue withCompletion:^(id object, NSError *error) {
                
                if (error==nil) {
                    [lMessage MR_deleteEntity];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                    NSInteger badgesCount = [[[self.tabBarController.tabBar.items objectAtIndex:2] badgeValue] integerValue];
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: --badgesCount];
                    NSString *badgeValue = --badgesCount > 0 ? [NSString stringWithFormat:@"%ld", badgesCount] : nil;
                    [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:badgeValue];
                    
                }
            }];
        }
        
    }];
}

#pragma mark - JSQMessagesCollectionViewDataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return _messages[indexPath.row];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *lMessage = _messages[indexPath.item];
    if ([lMessage.senderId isEqualToString:self.senderId]) {
        return _outgoingBubbleImageView;
    } else {
        return _incomingBubbleImageView;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *lMessage = _messages[indexPath.item];
    if ([lMessage.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor whiteColor];
    } else {
        cell.textView.textColor = [UIColor blackColor];
    }

    return cell;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
//    if ([message.senderId isEqualToString:self.senderId]) {
//        return nil;
//    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}
#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
//    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
//        return 0.0f;
//    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_messages count];
}

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    
    FIRDatabaseReference *chatRef = [_ref child:_channel];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSSZZZ"];
    
    NSDictionary *messageItem = @{
                                  @"author": senderDisplayName,
                                  @"date": [dateFormatter stringFromDate:date],
                                  @"message": text,
                                  @"senderId": senderId
                                  };
    
    FIRDatabaseReference *messageRef = [chatRef childByAutoId];
    [messageRef setValue:messageItem];
    
    // 4
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    // 5
    [self finishSendingMessage];
    
    NSDictionary *params = @{
                             @"receiver_id": _receiverId ? @(_receiverId) : @(_receiverUser.id_),
                             @"sender_id": senderId,
                             @"title": @"Message notification",
                             @"text": text,
                             @"channel": _channel,
                             @"date": [dateFormatter stringFromDate:date]
                             };
    
    [MGNetworkManager sendMessangerNotificationWihtParams:params withCompletion:^(id object, NSError *error) {
 
    }];
    
    Chat *lChat = [Chat MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel == %@", _channel]];
    
    if (!lChat) {
        
        lChat = [Chat MR_createEntity];
        lChat.channel = _channel;
        lChat.chatName = _receiverUser.name;
        lChat.receiverId = _receiverId ? @(_receiverId) : @(_receiverUser.id_);
        lChat.chatImageURL = [_receiverUser.smallImageURL absoluteString];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    
}

@end
