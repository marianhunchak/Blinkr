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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"Messages";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return [_chatsArray count];
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGChatController *vc = VIEW_CONTROLLER(@"MGChatController");
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.f;
}


@end
