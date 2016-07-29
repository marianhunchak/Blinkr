//
//  MGChatController.m
//  Blinkr
//
//  Created by Admin on 7/28/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGChatController.h"
#import "JSQMessages.h"
@import Firebase;

@interface MGChatController ()

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation MGChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.ref = [[FIRDatabase database] reference];
    
    
    _messages = [NSMutableArray array];
    
    self.senderId = @"14";
    self.senderDisplayName = @"Marian Hunchak";
    self.title = @"Chat";
    [self setupBubbles];
    
    // No avatars
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    [self observeMessages];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void) setupBubbles {
    
    JSQMessagesBubbleImageFactory *factory = [JSQMessagesBubbleImageFactory new];
    _outgoingBubbleImageView = [factory outgoingMessagesBubbleImageWithColor:mainAppColor];
    _incomingBubbleImageView = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
}

- (void) addMessageWithSenderID:(NSString *) senderID text:(NSString *) text {
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderID senderDisplayName:@"Marian Hunchak" date:[NSDate date] text:text];
    [_messages addObject:message];
    
}

- (void) observeMessages {
    // 1
    
    FIRDatabaseReference *chatRef = [_ref child:@"14_15"];
    FIRDatabaseQuery *messagesQuery = [chatRef queryLimitedToLast:25];
    
    [messagesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        [self addMessageWithSenderID:snapshot.value[@"senderId"] text:snapshot.value[@"message"]];
        
        [self finishReceivingMessage];
        
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
    
    FIRDatabaseReference *chatRef = [_ref child:@"14_15"];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY-mm-dd HH:mm:ss.ZZZ"];
    
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
}

@end
