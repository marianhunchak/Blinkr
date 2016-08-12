//
//  MGRateUserView.h
//  Blinkr
//
//  Created by Admin on 8/12/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MGRateUserView : UIView

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

+ (instancetype)loadRateUserView;

@end
