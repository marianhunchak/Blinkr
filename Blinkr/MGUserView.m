//
//  MGUserView.m
//  Blinkr
//
//  Created by Admin on 7/26/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGUserView.h"
#import "UIImageView+AFNetworking.h"

@interface MGUserView ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation MGUserView

+ (instancetype)loadUserView {
    
    NSArray *viewes = [[NSBundle mainBundle] loadNibNamed:@"MGUserView" owner:nil options:nil];
    
    MGUserView *newUserView = [viewes firstObject];
    
    return newUserView;
}



- (void)setImageURLString:(NSString *)imageURLString {
    
    _imageURLString = imageURLString;
    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [_userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user"]];
}



@end
