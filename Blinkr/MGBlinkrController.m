//
//  MGBlinkrController.m
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGBlinkrController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Blinkr-Swift.h"
#import "UIImageView+AFNetworking.h"
#import "MGNetworkManager.h"
#import "MGMapAnnotation.h"
#import "MGUserView.h"
#import "Chat.h"
#import "MGFileManager.h"
#import "Profile.h"
#import "MGUserInfoView.h"
#import "MGChatController.h"
#import "MGUserProfileViewController.h"
@import GLKit;
#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface MGBlinkrController () <MKMapViewDelegate, CLLocationManagerDelegate, MGUserViewDelegate, MGUserInfoViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet CCMRadarView *radarView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKUserLocation *userLocation;
@property (strong, nonatomic) MGUserInfoView *infoView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *usersViewsArray;

@end

CGFloat xKoef = 0;
CGFloat yKoef = 0;
CGFloat viliblePostionForInfoView;

@implementation MGBlinkrController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 2.0;
    self.userImageView.layer.borderColor = RGBHColor(0xFF6600).CGColor;
    
    
    xKoef = 0.124274 / CGRectGetMinX(_userImageView.frame);
    yKoef = 0.124274 / CGRectGetMinY(_userImageView.frame);
    
    UITapGestureRecognizer *tapOnUserImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnUserImageView)];
    [self.userImageView addGestureRecognizer:tapOnUserImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnView)];
    [self.view addGestureRecognizer:tapGesture];

    
    [self.mapView setDelegate:self];
    [self.radarView startAnimation];
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.mapView.showsUserLocation = YES;
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                                  target: self
                                                selector:@selector(onTick)
                                                userInfo: nil repeats:YES];
    [self getNearestUsers];
    
//    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    _infoView = [MGUserInfoView loadUserInfoView];
    _infoView.delegate = self;
    _infoView.frame = CGRectMake(0.f,
                                 self.view.frame.size.height,
                                 self.view.frame.size.width,
                                 90.f);
    
    viliblePostionForInfoView = _infoView.frame.origin.y - (_infoView.frame.size.height + self.tabBarController.tabBar.frame.size.height + self.tabBarController.navigationController.navigationBar.frame.size.height + 20.f);
    
    [self.radarView startAnimation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blinkr"]];
    self.tabBarController.navigationItem.titleView = titleImageView;
    self.tabBarController.navigationItem.title = @"";
    [self.radarView startAnimation];
    
    Profile *lProfile = [Profile MR_findFirst];
    
    if ([lProfile.pictureURL hasPrefix:@"http"]) {
        
        __weak typeof(self) weakSelf = self;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lProfile.pictureURL]];
        
        [self.userImageView setImageWithURLRequest:request placeholderImage:nil
         
                                          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                              
                                              weakSelf.userImageView.image = image;
                                              lProfile.pictureURL = [MGFileManager writeProfileImageToDocuments:image];
                                              
                                          } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                              
                                          }];
        
    } else {
        
        self.userImageView.image = [MGFileManager getProfileImageFromDocuments];
    }
    
    [self.radarView startAnimation];
    
}

#pragma mark - MGUserViewDelegate

- (void)userViewDelegateTappedOnUserView:(MGUserView *)selectedUserView {
    
    _infoView.userID = selectedUserView.selectedUserID;
    
    [self.view addSubview:_infoView];
    
    [UIView animateWithDuration:0.25 animations:^{
        _infoView.frame = CGRectMake(0,
                                     viliblePostionForInfoView,
                                     _infoView.frame.size.width,
                                     _infoView.frame.size.height);
    }];
    
}

#pragma mark - MGUserInfoViewDelegate

- (void)userInfoViewDelegateSendMessageBtnPressed:(MGUser *)user {
    
    MGChatController *vc = VIEW_CONTROLLER(@"MGChatController");
    vc.receiverUser = user;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)userInfoViewDelegateUserButtonPresed:(MGUser *)user {
    
    
    MGUserProfileViewController *vc = VIEW_CONTROLLER(@"MGUserProfileViewController");
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Actions

- (void)tappedOnUserImageView {
    
    [self.tabBarController.delegate tabBarController:self.tabBarController shouldSelectViewController:[[self.tabBarController viewControllers] objectAtIndex:2]];
    [self.tabBarController setSelectedIndex:3];
 
}

- (void)handleTapOnView {
    
    [UIView animateWithDuration:0.25 animations:^{
        _infoView.frame = CGRectMake(0,
                                     self.view.frame.size.height,
                                     _infoView.frame.size.width,
                                     _infoView.frame.size.height);
    }];
    
}

- (void)getNearestUsers {
    
    [MGNetworkManager getNearestUsersWithRadius:100000 withCompletion:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            for (MGUserView *lUserView in _usersViewsArray) {
                
                lUserView.image = nil;
                lUserView.hidden = YES;
                
            }
            
             CLLocationDirection mapAngle = self.mapView.camera.heading;
            
            NSLog(@"MapAngle = %f", mapAngle);
            
            NSInteger counter = 0;
            
            for (NSDictionary* dict in array) {
                CLLocationCoordinate2D coordinate;
                
                NSInteger profileID = [[NSUserDefaults standardUserDefaults] integerForKey:PROFILE_ID_KEY];
                
                
                
                if ([dict[@"latitude"] isKindOfClass:[NSNull class]] || [dict[@"id"] integerValue] == profileID) {
                    continue;
                }
                coordinate.latitude = [dict[@"latitude"]doubleValue];
                coordinate.longitude = [dict[@"longitude"]doubleValue];
                
                float heading = [self getHeadingForDirectionFromCoordinate:self.userLocation.coordinate toCoordinate:coordinate];
                
                NSLog(@"Heading = %f", heading);
                
                MGUserView *userView = _usersViewsArray[counter];
                userView.hidden = NO;
                userView.delegate = self;
                userView.selectedUserID = [dict[@"id"] integerValue];
                userView.imageURLString = dict[@"picture"][@"small_picture_url"];
                            
                
//                [self setFrameForUserView:userView WithDicr:dict];
                
                userView.layer.cornerRadius = userView.frame.size.width / 2.0;
                userView.layer.masksToBounds = YES;
                
                counter++;
            }
        }
    }];
}

- (void) setFrameForUserView:(MGUserView *)userView WithDicr:(NSDictionary *)dict {
    
    float cosX = cos(GLKMathDegreesToRadians([dict[@"bearing"] integerValue]));
    
    float sinY = sin(GLKMathDegreesToRadians([dict[@"bearing"] integerValue]));
    
    double distance = [dict[@"distance"]doubleValue];
    
    userView.frame = CGRectMake(0, 0, 50, 50);
    
    userView.center = CGPointMake(_userImageView.center.x + (distance / xKoef * cosX) + [self signOfInteger:cosX] * (_userImageView.frame.size.width / 2.0),
                                  _userImageView.center.y + (distance / yKoef * sinY) + [self signOfInteger:sinY] * (_userImageView.frame.size.width / 2.0));
    
}

- (int)signOfInteger:(float)integer {
    
    if (integer < 0) {
        return -1;
    }
    
    return 1;
    
}

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}

- (void)onTick {
    
    [self.locationManager startUpdatingLocation];
    
    [self getNearestUsers];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestWhenInUseAuthorization];
        return;
        
    }
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locationManager startUpdatingLocation];
        [self.locationManager stopUpdatingLocation];
        
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    [MGNetworkManager updateCurrentUserLocationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude withCompletion:nil];

    self.userLocation = userLocation;
    
//    [self.mapView setCenterCoordinate:userLocation.coordinate animated:NO];
    
//    MKCoordinateRegion region;
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.05;
//    span.longitudeDelta = 0.05;
//    CLLocationCoordinate2D location;
//    location.latitude = self.userLocation.coordinate.latitude;
//    location.longitude = self.userLocation.coordinate.longitude;
//    region.span = span;
//    region.center = location;
//    [self.mapView setRegion:region animated:NO];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"Annotation";
    
    MKAnnotationView *aView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!aView) {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        aView.image = [UIImage imageNamed:@"user"];
        aView.canShowCallout = NO;
        
    } else {
        aView.annotation = annotation;
    }
    
    return aView;
}


@end
