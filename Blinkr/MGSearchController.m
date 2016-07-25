//
//  MGSearchControllerTableViewController.m
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGSearchController.h"

@interface MGSearchController () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation MGSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _searchBar.delegate = self;
    
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - Actions

- (void)handleTapOnView {
    
    [self.searchBar resignFirstResponder];
}

@end
