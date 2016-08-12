//
//  MGRateUserView.m
//  Blinkr
//
//  Created by Admin on 8/12/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGRateUserView.h"

@interface MGRateUserView ()

@end

@implementation MGRateUserView

+ (instancetype)loadRateUserView {
    
    NSArray *viewes = [[NSBundle mainBundle] loadNibNamed:@"MGRateUserView" owner:nil options:nil];
    
    MGRateUserView *newRateUserView = [viewes firstObject];
    
    return newRateUserView;
}

@end
