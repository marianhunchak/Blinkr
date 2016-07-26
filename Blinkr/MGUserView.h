//
//  MGUserView.h
//  Blinkr
//
//  Created by Admin on 7/26/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGUserView : UIView

+ (instancetype)loadUserView;
@property(strong, nonatomic) NSString *imageURLString;

@end
