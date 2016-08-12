//
//  MGMyProfileViewController.m
//  S3XTesla
//
//  Created by Marian on 31.05.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGMyProfileViewController.h"
#import "MGFetchUserInfo.h"
#import "MGNetworkManager.h"
#import "HCSStarRatingView.h"
#import "UIView+Layer.h"
#import "MGOptionsController.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "MGFileManager.h"

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
    
    
    [self configureUserInterface];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdatedHandling:) name:PROFILE_UPDATED_KEY object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
    self.tableView.estimatedRowHeight = 100.f;
    
    [self.tabBarController.navigationItem setHidesBackButton:YES animated:NO];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"Profile";
    
    UIBarButtonItem *optionsBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"optionsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showOptionsController:)];
    self.tabBarController.navigationItem.rightBarButtonItem = optionsBtn;
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

- (void)configureUserInterface {
    
    Profile *lProfile = [Profile MR_findFirst];
    
    self.emailLabel.text = ![lProfile.email isEqualToString:@""] ? lProfile.email : @"Email";

    self.firstNameLabel.text = ![lProfile.name isEqualToString:@""] ? lProfile.name : @"Name";

    self.bioLabel.text = ![lProfile.bio isEqualToString:@""] ? lProfile.bio : @"Bio";

    self.phoneNumberLabel.text = ![lProfile.phone_number isEqualToString:@""] ? lProfile.phone_number : @"Phone number";

    self.modelTeslaLabel.text = ![lProfile.car_model isEqualToString:@""] ? lProfile.car_model : @"Car model";

    self.licansePlateLabel.text = ![lProfile.license_plate isEqualToString:@""] ? lProfile.license_plate : @"License plate";

    self.facebookLinkLabel.text = ![lProfile.facebook_link isEqualToString:@""] ? lProfile.facebook_link : @"Facebook link";
    
    self.ratingView.value = [lProfile.rate floatValue];
    
    [self.tableView reloadData];

    
    if ([lProfile.pictureURL hasPrefix:@"http"]) {
        
        __weak typeof(self) weakSelf = self;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lProfile.pictureURL]];
        
        [self.profileImage setImageWithURLRequest:request placeholderImage:nil
    
        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            weakSelf.profileImage.image = image;
            lProfile.pictureURL = [MGFileManager writeProfileImageToDocuments:image];
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
        
    } else {
        
        self.profileImage.image = [MGFileManager getProfileImageFromDocuments];
    }
    
    

}

#pragma mark - Actions

- (void)showOptionsController:(UIBarButtonItem *) sender {
    
    MGOptionsController *editMyProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MGOptionsController"];
    [self.navigationController pushViewController:editMyProfileViewController animated:YES];
}

#pragma mark - Notifications

- (void) profileUpdatedHandling:(NSNotification *) notification {
    
    [self configureUserInterface];
}


@end
