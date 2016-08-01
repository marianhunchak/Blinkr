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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"Messages";
    
    self.chatsArray = [Chat MR_findAll];
    
    [MGNetworkManager getAllNotificationsWithCompletion:^(NSArray *array, NSError *error) {
        if (array) {
            
            for (Message *lMessage in array) {
                
                Chat *lChat = [Chat MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"channel == %@", lMessage.channel]];
                
                if (!lChat) {
                    
                    lChat = [Chat MR_createEntity];
                    lChat.channel = lMessage.channel;
                    lChat.chatName = lMessage.senderName;
                }
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            self.chatsArray = [Chat MR_findAll];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGChatController *vc = VIEW_CONTROLLER(@"MGChatController");
    Chat *lChat = _chatsArray[indexPath.row];
    vc.channel = lChat.channel;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}


@end
