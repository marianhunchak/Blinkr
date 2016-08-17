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
#import "UIImageView+AFNetworking.h"

@import Firebase;

@interface MGMessagesController () <UITableViewDataSource, UITableViewDelegate>

#pragma mark - Properties
@property (strong, nonatomic) NSArray *chatsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noMessagesView;

@end

static NSString *cellIdentifier = @"messageCell";

@implementation MGMessagesController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"MGMessageCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.tableFooterView = [UIView new];
    
    [MGNetworkManager getAllNotificationsWithCompletion:^(NSArray *array, NSError *error) {
        if (array) {
            
            [self saveContext];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived) name:@"notification_received" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"Messages";
    
//    self.chatsArray = [Chat MR_findAll];
    [self saveContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Notifications

- (void) notificationReceived {
    
    [self saveContext];
}

- (void) tappedOnNotification {
    
    MGChatController *vc = VIEW_CONTROLLER(@"MGChatController");
    self.tabBarController.navigationItem.title = @"";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private methods

- (void)saveContext {
    
    NSArray *messagesArray = [Notification MR_findAll];
    
    for (Notification *lNotification in messagesArray) {
        
        Chat *lChat = [Chat MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel == %@", lNotification.channel]];
        
        if (!lChat) {
            lChat = [Chat MR_createEntity];
        }
        
        lChat.channel = lNotification.channel;
        lChat.chatName = lNotification.senderName;
        lChat.receiverId = lNotification.sender_id;
        lChat.chatImageURL = lNotification.senderPictureURL;
        lChat.lastMessageDate = lNotification.dateString;
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    self.chatsArray = [Chat MR_findAllSortedBy:@"lastMessageDate" ascending:NO];
    
    if ([_chatsArray count] == 0) {
        _noMessagesView.hidden = NO;
    } else {
        _noMessagesView.hidden = YES;
        [self.tableView reloadData];
    }

    NSString *badgeValue = [messagesArray count] > 0 ? [NSString stringWithFormat:@"%ld", [messagesArray count]] : nil;
    [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:badgeValue];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeValue.integerValue;
    
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
    
    Notification *lNotification = [Notification MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel = %@", lChat.channel]];
    
    if (lNotification) {
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
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

- (void)openChatWithNotification:(Notification *)notification {
    
    MGChatController *vc = VIEW_CONTROLLER(@"MGChatController");
    vc.channel = notification.channel;
    vc.receiverId = [notification.sender_id integerValue];
    vc.chatName = notification.senderName;
    vc.chatImageURL = notification.senderPictureURL;
    self.tabBarController.navigationItem.title = @"";
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [vc deleteNotficationWhithChannel:notification.channel];
}


@end
