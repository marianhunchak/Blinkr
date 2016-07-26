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

    UIBarButtonItem *sendMessageBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mail"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(sendMessageBtnPressed)];
    self.navigationItem.rightBarButtonItem = sendMessageBtn;
    
    self.navigationItem.title = _user.name;
    
    _nameLabel.text = _user.name;
    _ratingView.value = _user.rate;
    _emailTextView.text = _user.email;
    _phoneNumberTextView.text = _user.phoneNumber;
    _teslaModelLabel.text = _user.teslaModel == nil ? @"Car model" : _user.teslaModel;
    _licensePlateLabel.text = _user.licensePlate;
    _facebookLinkTextView.text = _user.facebookLink;
    _bioTextView.text = _user.bio == nil ? @"User bio" : _user.bio;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_user.imageURL];
    
    [self.userImageView setImageWithURLRequest:request placeholderImage:nil
     
    success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        self.userImageView.image = image;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma mark - API


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
    
}


@end
