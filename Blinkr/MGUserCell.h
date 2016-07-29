//
//  MGUserCell.h
//  Blinkr
//
//  Created by Admin on 7/26/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGUser.h"

@class MGUserCell;

@protocol MGUserCellDelegate <NSObject>

- (void)userCellDelegateSendMessageBtnPressed;

@end

@interface MGUserCell : UITableViewCell

@property (strong, nonatomic) MGUser *user;
@property (weak, nonatomic) id <MGUserCellDelegate> delegate;

@end
