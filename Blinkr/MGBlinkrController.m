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

@interface MGBlinkrController ()


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet CCMRadarView *radarView;

@end

@implementation MGBlinkrController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 2.0;
    self.userImageView.layer.borderColor = RGBHColor(0xFF6600).CGColor;
    
    [self.radarView startAnimation];
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
