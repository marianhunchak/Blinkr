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

@interface SignInController () <FBSDKLoginButtonDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *viewForHiddenFB;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (nonatomic, retain) NSTimer *myTimer;
@property (strong, nonatomic) NSArray *imagesNameArray;
@end

@implementation SignInController

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pushController];
    
    [self.checkBox setSelected:YES];
    [self chekBoxBtnPressed:self.checkBox];

    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                    target:self
                                                  selector:@selector(showNextCollectionItem)
                                                  userInfo:nil
                                                   repeats:YES];
    
    self.imagesNameArray = @[@"front_page_1.png",
                             @"front_page_2.png",
                             @"front_page_3.png",
                             @"front_page_4.png"];
    
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
    
    if (self.myTimer.isValid) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
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
                                          
                                          [hd failAndDismissWithTitle:@"Something went wrong"];
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
                                                  [hd failAndDismissWithTitle:@"Something went wrong"];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imagesNameArray[indexPath.item]]];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.backgroundView = imageView;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return collectionView.frame.size;
}

- (void) showNextCollectionItem {
    
    NSIndexPath *curentIndexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
    
    NSInteger nextItemIndex = curentIndexPath.item + 1;
    
    if (nextItemIndex > 3) {
        nextItemIndex = 0;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItemIndex inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.pageControl.currentPage = nextItemIndex;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    self.pageControl.currentPage = (floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
}


@end
