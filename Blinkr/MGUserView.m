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

@end

@implementation MGUserView

+ (instancetype)loadUserView {
    
    NSArray *viewes = [[NSBundle mainBundle] loadNibNamed:@"MGUserView" owner:nil options:nil];
    
    MGUserView *newUserView = [viewes firstObject];
    
    newUserView.layer.borderWidth = 2.f;
    newUserView.layer.borderColor = [newUserView randomColor].CGColor;
    newUserView.layer.masksToBounds = YES;
    
    
    
    return newUserView;
}



- (void)setImageURLString:(NSString *)imageURLString {
    
    _imageURLString = imageURLString;
    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [self setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user"]];
    
    UITapGestureRecognizer *tapOnOtherUserImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnUserView)];
    [self addGestureRecognizer:tapOnOtherUserImageView];
}

- (UIColor *)randomColor {
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)tappedOnUserView {
    
    if (self.delegate) {
        [self.delegate userViewDelegateTappedOnUserView:self];
    }
    
}

@end
