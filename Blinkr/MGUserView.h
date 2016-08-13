//
//  MGUserView.h
//  Blinkr
//
//  Created by Admin on 7/26/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGUserView;

@protocol MGUserViewDelegate <NSObject>

- (void)userViewDelegateTappedOnUserView:(MGUserView *)selectedUserView;

@end

@interface MGUserView : UIImageView

@property (strong, nonatomic) NSString *imageURLString;
@property (assign, nonatomic) NSInteger selectedUserID;
@property (weak, nonatomic) id <MGUserViewDelegate> delegate;

+ (instancetype)loadUserView;

@end
