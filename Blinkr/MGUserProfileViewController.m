//
//  MGUserProfileViewController.m
//  T
//
//  Created by Орест on 22.06.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGUserProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "HCSStarRatingView.h"
#import "MGUser.h"
#import "UIView+Layer.h"
#import "MGChatController.h"

@interface MGUserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *emailTextView;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumberTextView;
@property (weak, nonatomic) IBOutlet UILabel *teslaModelLabel;
@property (weak, nonatomic) IBOutlet UITextView *facebookLinkTextView;
@property (weak, nonatomic) IBOutlet UILabel *licensePlateLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UITableView *chargersTableView;
@property (strong, nonatomic) UIRefreshControl *chargersRefreshControll;
@property (strong, nonatomic) NSArray *chargersArray;

@property (assign, nonatomic) BOOL showChargersTableView;

@end

@implementation MGUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.tableFooterView = [UIView new];

    UIBarButtonItem *sendMessageBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chatItem"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(sendMessageBtnPressed)];
    self.navigationItem.rightBarButtonItem = sendMessageBtn;
    
    [self setUserInfo:_user];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_userId && _user == nil) {
        [self getUserInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationItem.title = @"";
}


#pragma mark - API


- (void) getUserInfo {
    
    __weak typeof(self) weakSelf = self;
    
    [MGNetworkManager getUserWithID:_userId withCompletion:^(id object, NSError *error) {
    
        if (object) {
        
            [weakSelf setUserInfo:object];
            weakSelf.user = object;
            [weakSelf.tableView reloadData];
        }

    }];
    
}

#pragma mark - Private methods 

- (void) setUserInfo:(MGUser *) user {
    
    self.navigationItem.title = user.name;
    
    _nameLabel.text = user.name;
    _ratingView.value = user.rate;
    _emailTextView.text = user.email;
    _phoneNumberTextView.text = user.phoneNumber;
    _teslaModelLabel.text = user.teslaModel == nil ? @"Car model" : user.teslaModel;
    _licensePlateLabel.text = user.licensePlate;
    _facebookLinkTextView.text = user.facebookLink;
    _bioTextView.text = user.bio == nil ? @"Bio" : user.bio;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:user.imageURL];
    
    [self.userImageView setImageWithURLRequest:request placeholderImage:nil
     
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           self.userImageView.image = image;
                                           
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                           NSLog(@"Error: %@", error);
                                           
                                       }];
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != 0) {
        [_userImageView addGradientToView];
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.row == 0) {
            return self.view.frame.size.height / 2.5;
        }

        if (indexPath.row == 1 && !_user.showEmail) {
            return  0.0f;
        }
        
        if (indexPath.row == 2 && !_user.showPhoneNumber) {
            return  0.0f;
        }
        
        if (indexPath.row == 4 && !_user.showLicensePlate) {
            return  0.0f;
        }
        
        if (indexPath.row == 5 && !_user.showFacebookLink) {
            return  0.0f;
        }
        
        return UITableViewAutomaticDimension;

}

#pragma mark - Actions

- (void) sendMessageBtnPressed {
    
    if (_user) {
        MGChatController *vc = VIEW_CONTROLLER(@"MGChatController");
        vc.receiverUser = _user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
