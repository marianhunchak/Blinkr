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

@interface MGBlinkrController () <MKMapViewDelegate, CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet CCMRadarView *radarView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *userViewsArray;
@property (strong, nonatomic) MKUserLocation *userLocation;
@end

@implementation MGBlinkrController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _userViewsArray = [NSMutableArray array];
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 2.0;
    self.userImageView.layer.borderColor = RGBHColor(0xFF6600).CGColor;
    
    [self.mapView setDelegate:self];
    [self.radarView startAnimation];
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.mapView.showsUserLocation = YES;
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                  target: self
                                                selector:@selector(onTick)
                                                userInfo: nil repeats:YES];
    [self getNearestUsers];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blinkr"]];
    self.tabBarController.navigationItem.titleView = titleImageView;
    [self.radarView startAnimation];
    
    NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:PROFILE_PICTURE_URL]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    [self.userImageView setImageWithURLRequest:request placeholderImage:nil
     
    success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        self.userImageView.image = image;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        
        
    }];
    
    }

- (void) getNearestUsers {
    
    [MGNetworkManager getNearestUsersWithRadius:10 withCompletion:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            for (MGUserView *lUserView in _userViewsArray) {
                
                [lUserView removeFromSuperview];
                
            }
            
            [_userViewsArray removeAllObjects];
            
            for (NSDictionary* dict in array) {
                CLLocationCoordinate2D coordinate;
                
                NSInteger profileID = [[NSUserDefaults standardUserDefaults] integerForKey:PROFILE_ID_KEY];
                
                
                
                if ([dict[@"latitude"] isKindOfClass:[NSNull class]] || [dict[@"id"] integerValue] == profileID) {
                    continue;
                }
                coordinate.latitude = [dict[@"latitude"]doubleValue];
                coordinate.longitude = [dict[@"longitude"]doubleValue];
                
                MGUserView *userView = [MGUserView loadUserView];
                userView.imageURLString = dict[@"picture"][@"small_picture_url"];
                
                userView.frame = CGRectMake(0, 0, 50, 50);
                
                userView.center = [self.mapView convertCoordinate:coordinate toPointToView:self.view];
                userView.layer.cornerRadius = userView.frame.size.width / 2.0;
                userView.layer.masksToBounds = YES;
                
                [_userViewsArray addObject:userView];
                
                [self.view addSubview:userView];
                
                
                
            }
        }
    }];
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
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.001;
    CLLocationCoordinate2D location;
    location.latitude = self.mapView.userLocation.coordinate.latitude;
    location.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:NO];
    
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
