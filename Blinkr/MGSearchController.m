//
//  MGSearchControllerTableViewController.m
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGSearchController.h"
#import "MGUserCell.h"
#import "MGNetworkManager.h"
#import "MGUserProfileViewController.h"

@interface MGSearchController () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *usersArray;

@end

static NSString *cellReuseIdentifier = @"userCell";

@implementation MGSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshTable:self.refreshControl];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"Search";
    
    UINib *nib = [UINib nibWithNibName:@"MGUserCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.tableFooterView = [UIView new];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnView)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tabBarController.navigationItem setHidesBackButton:YES];
    self.tabBarController.navigationItem.titleView = _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_usersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    cell.user = _usersArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGUserProfileViewController *vc = VIEW_CONTROLLER(@"MGUserProfileViewController");
    vc.user = _usersArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.f;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self searchUsersWithString:searchBar.text];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchUsersWithString:searchBar.text];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = @"";
    
    [searchBar resignFirstResponder];
    
    [self searchUsersWithString:@""];
    
}

#pragma mark - API

- (void)refreshTable:(UIRefreshControl *) refreshControl {
    
    [self searchUsersWithString:@""];
}

- (void) searchUsersWithString:(NSString *) searchString {
    
    [self.refreshControl beginRefreshing];
    
    __weak typeof(self) weakSelf = self;
    
    [MGNetworkManager searchUsersWithString:searchString withCompletion:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            weakSelf.usersArray = array;
            [weakSelf.tableView reloadData];
            
        }
        
        [weakSelf.refreshControl endRefreshing];
        
    }];
}

#pragma mark - Actions

- (void)handleTapOnView {
    
    [self.searchBar resignFirstResponder];
    
    
}

@end
