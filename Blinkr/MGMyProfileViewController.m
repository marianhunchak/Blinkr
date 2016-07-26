//
//  MGMyProfileViewController.m
//  S3XTesla
//
//  Created by Marian on 31.05.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGMyProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "MGNetworkManager.h"
#import "MGFetchUserInfo.h"
#import "MGNetworkManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UIImageView+AFNetworking.h"
#import "HCSStarRatingView.h"
#import "UIView+Layer.h"
#import "MGEditMyProfileViewController.h"


@interface MGMyProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelTeslaLabel;
@property (weak, nonatomic) IBOutlet UILabel *licansePlateLabel;
@property (weak, nonatomic) IBOutlet UILabel *facebookLinkLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *miniProfileImage;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;

@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) NSString *userToken;

@property (strong, nonatomic) MGFetchUserInfo *userInfo;

@end

@implementation MGMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self fetchUserProfile];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdatedHandling:) name:PROFILE_UPDATED_KEY object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
    self.tableView.estimatedRowHeight = 100.f;
    
    [self.tabBarController.navigationItem setHidesBackButton:YES animated:NO];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"Profile";
    
    UIBarButtonItem *logOutBtn = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOutBtnPressed:)];
    self.tabBarController.navigationItem.leftBarButtonItem = logOutBtn;
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editMyProfileAction:)];
    self.tabBarController.navigationItem.rightBarButtonItem = editBtn;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (NSString *) storyboardID {
    return @"MGMyProfileViewController";
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 1 ) {
        
        [_profileImage addGradientToView];
        
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return self.tableView.frame.size.height / 2.5f;
    }
    
    return UITableViewAutomaticDimension;
}


#pragma mark - self API

- (void) fetchUserProfile {
    
    NSString *facebookToken = [[NSUserDefaults standardUserDefaults] stringForKey:FACEBOOK_TOKEN_KEY];

    [MGNetworkManager loginWithFacebookToken:facebookToken firebaseToken:@"" withCompletion:^(id object, NSError *error) {
        
        if (object) {
            [self setLabelTextWithDict:object];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
    }];
    
}

- (void) setLabelTextWithDict:(NSDictionary *)dcit {
    
    _userInfo = [[MGFetchUserInfo alloc] initWithServerRespons:dcit];
    
    self.emailLabel.text = _userInfo.email ? _userInfo.email : @"Email";

    self.firstNameLabel.text = _userInfo.name ? _userInfo.name : @"Name";

    self.bioLabel.text = _userInfo.bio ? _userInfo.bio : @"Bio";

    self.phoneNumberLabel.text = _userInfo.phoneNumber ? _userInfo.phoneNumber : @"Phone number";

    self.modelTeslaLabel.text = _userInfo.teslaModel ? _userInfo.teslaModel : @"Car model";

    self.licansePlateLabel.text = _userInfo.licensePlate ? _userInfo.licensePlate : @"License plate";

    self.facebookLinkLabel.text = _userInfo.facebookLink ? _userInfo.facebookLink : @"Facebook link";
    
    self.ratingView.value = _userInfo.rate;
    
    [self.tableView reloadData];

    NSURLRequest *request = [NSURLRequest requestWithURL:_userInfo.imageURL];
    
    __weak typeof(self) weakSelf = self;
    
    [weakSelf.profileImage setImageWithURLRequest:request
                                     placeholderImage:nil
                                              success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

                                                  weakSelf.profileImage.image = image;
                                                  
                                              }
                                              failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                  NSLog(@"%@",error.localizedDescription);
                                              } ];

}

#pragma mark - Actions

- (void)logOutBtnPressed:(UIBarButtonItem *) sender {
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}


- (void)editMyProfileAction:(UIBarButtonItem *) sender {
    
    MGEditMyProfileViewController *editMyProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MGEditMyProfileViewController"];
    editMyProfileViewController.userInfo = _userInfo;
    editMyProfileViewController.userImage = _profileImage.image;

    [self.navigationController pushViewController:editMyProfileViewController animated:YES];
}

#pragma mark - Notifications

- (void) profileUpdatedHandling:(NSNotification *) notification {
    
    [self fetchUserProfile];
}


@end
