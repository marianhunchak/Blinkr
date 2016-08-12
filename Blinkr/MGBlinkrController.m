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
@import GLKit;
#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface MGBlinkrController () <MKMapViewDelegate, CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet CCMRadarView *radarView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *userViewsArray;
@property (strong, nonatomic) MKUserLocation *userLocation;

@end

CGFloat xKoef = 0;
CGFloat yKoef = 0;

@implementation MGBlinkrController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _userViewsArray = [NSMutableArray array];
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 2.0;
    self.userImageView.layer.borderColor = RGBHColor(0xFF6600).CGColor;
    
    
    xKoef = 0.124274 / CGRectGetMinX(_userImageView.frame);
    yKoef = 0.124274 / CGRectGetMinY(_userImageView.frame);
    
    UITapGestureRecognizer *tapOnUserImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnUserImageView)];
    [self.userImageView addGestureRecognizer:tapOnUserImageView];
    
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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blinkr"]];
    self.tabBarController.navigationItem.titleView = titleImageView;
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
    
    }

#pragma mark - Actions 

- (void)tappedOnUserImageView {
    
    [self.tabBarController.delegate tabBarController:self.tabBarController shouldSelectViewController:[[self.tabBarController viewControllers] objectAtIndex:2]];
    [self.tabBarController setSelectedIndex:3];
    
}

- (void) getNearestUsers {
    
    [MGNetworkManager getNearestUsersWithRadius:10 withCompletion:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            for (MGUserView *lUserView in _userViewsArray) {
                
                [lUserView removeFromSuperview];
                
            }
            
            [_userViewsArray removeAllObjects];
            
             CLLocationDirection mapAngle = self.mapView.camera.heading;
            
            NSLog(@"MapAngle = %f", mapAngle);
            
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
                
                MGUserView *userView = [MGUserView loadUserView];
                userView.imageURLString = dict[@"picture"][@"small_picture_url"];
                
                [self setFrameForUserView:userView WithDicr:dict];
                
                userView.layer.cornerRadius = userView.frame.size.width / 2.0;
                
                [_userViewsArray addObject:userView];
                
                [self.view addSubview:userView];
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
