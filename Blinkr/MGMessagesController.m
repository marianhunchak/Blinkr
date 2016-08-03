//
//  MGMessagesController.m
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGMessagesController.h"
#import "MGChatController.h"
#import "MGMessageCell.h"
#import "MGNetworkManager.h"
#import "Chat.h"
#import "Message.h"
#import "UIImageView+AFNetworking.h"

@import Firebase;

@interface MGMessagesController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *chatsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *cellIdentifier = @"messageCell";

@implementation MGMessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"MGMessageCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.tableFooterView = [UIView new];
    
//        [Message MR_truncateAll];
//        [Chat MR_truncateAll];
//    
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    
//    [MGNetworkManager deleteNotificationWithID:185 withCompletion:^(id object, NSError *error) {
//        
//        if (error==nil) {
//            
//        }
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived) name:@"notification_received" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"Messages";
    
    self.chatsArray = [Chat MR_findAll];
    
    [MGNetworkManager getAllNotificationsWithCompletion:^(NSArray *array, NSError *error) {
        if (array) {
            
            NSArray *messagesArray = [Message MR_findAll];
            
            for (Message *lMessage in messagesArray) {
                
                Chat *lChat = [Chat MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel == %@", lMessage.channel]];
                
                if (!lChat) {
                    
                    lChat = [Chat MR_createEntity];
                    lChat.channel = lMessage.channel;
                    lChat.chatName = lMessage.senderName;
                    lChat.receiverId = lMessage.sender_id;
                    lChat.chatImageURL = lMessage.senderPictureURL;
                }
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            self.chatsArray = [Chat MR_findAll];
            [self.tableView reloadData];
            
            NSString *badgeValue = [messagesArray count] > 0 ? [NSString stringWithFormat:@"%ld", [messagesArray count]] : nil;
            [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:badgeValue];
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notifications

- (void) notificationReceived {
    
    [self viewWillAppear:NO];
}

#pragma mark - Private methods

- (void)saveContext {
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_chatsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Chat *lChat = _chatsArray[indexPath.row];
    cell.userNameLabel.text = lChat.chatName;
    cell.channel = lChat.channel;
    [cell.userImageView setImageWithURL:[NSURL URLWithString:lChat.chatImageURL] placeholderImage:[UIImage imageNamed:@"user"]];
    
    Message *lMessage = [Message MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel = %@", lChat.channel]];
    
    if (lMessage) {
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGChatController *vc = VIEW_CONTROLLER(@"MGChatController");
    Chat *lChat = _chatsArray[indexPath.row];
    vc.channel = lChat.channel;
    vc.receiverId = [lChat.receiverId integerValue];
    vc.chatName = lChat.chatName;
    vc.chatImageURL = lChat.chatImageURL;
    self.tabBarController.navigationItem.title = @"";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}


@end
