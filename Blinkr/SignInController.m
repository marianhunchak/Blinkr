//
//  SignInController.m
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "SignInController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SAMHUDView.h"
#import "Profile.h"
#import "MGTermsOfUseController.h"
@import FirebaseAuth;
@import Firebase;

#define SBSI_GO_TO_TabBarController @"showTabBarController"

@interface SignInController () <FBSDKLoginButtonDelegate>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *viewForHiddenFB;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@end

@implementation SignInController

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pushController];
    
    [self.checkBox setSelected:YES];
    [self chekBoxBtnPressed:self.checkBox];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    self.loginButton.delegate = self;
    self.loginButton.userInteractionEnabled = NO;
    
    self.navigationItem.title = @"Sign In";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void) pushController {

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY]) {
        
        [self performSegueWithIdentifier:SBSI_GO_TO_TabBarController sender:self];
        
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:SBSI_GO_TO_FILTER]) {
//        FiltersViewController *filterVC = segue.destinationViewController;
//        filterVC.filter = _searchFilter;
//    }
}


#pragma mark - FBSDKLoginButtonDelegate

- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    if (error == nil && result.token) {
        
        
        NSString *facebookToken = [[FBSDKAccessToken currentAccessToken] tokenString];
        
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:facebookToken];
        
        
        SAMHUDView *hd = [[SAMHUDView alloc] initWithTitle:@"" loading:YES];
        [hd show];
        
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      if (error) {
                                          NSLog(@"Login failed. %@", error);
                                          
                                          [hd failAndDismissWithTitle:[error localizedDescription]];
                                          [FBSDKAccessToken setCurrentAccessToken:nil];
                                          FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                                          [loginManager logOut];
                                          
                                      } else {
                                          [[NSUserDefaults standardUserDefaults] setObject:facebookToken forKey:FACEBOOK_TOKEN_KEY];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          
                                          [MGNetworkManager loginWithFacebookToken:facebookToken firebaseToken:nil withCompletion:^(id object, NSError *error) {
                                              
                                              if (object) {
                                                  
                                                  [Profile initWithDict:object];
                                                  [hd completeAndDismissWithTitle:@""];
                                                  [self pushController];
                                                  
                                              } else {
                                                  
                                                  [FBSDKAccessToken setCurrentAccessToken:nil];
                                                  FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                                                  [loginManager logOut];
                                                  [hd failAndDismissWithTitle:[error localizedDescription]];
                                              }
                                              
                                          }];
                                          
                                      }

        }];
 
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

#pragma mark - Actions

- (IBAction)chekBoxBtnPressed:(UIButton *)sender {
    
    if (sender.selected) {
        [sender setSelected:NO];
        self.loginButton.userInteractionEnabled = NO;
        self.viewForHiddenFB.hidden = NO;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [sender setSelected:YES];
        }];
        
        
        self.loginButton.userInteractionEnabled = YES;
        self.viewForHiddenFB.hidden = YES;
    }
    
}

- (IBAction)termsOfUseBtnPressed:(id)sender {
    
    MGTermsOfUseController *termsOfUseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MGTermsOfUseController"];
    [self.navigationController pushViewController:termsOfUseVC animated:YES];
}


@end
