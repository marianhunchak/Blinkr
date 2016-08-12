//
//  MGTermsOfUseController.m
//  T
//
//  Created by Admin on 7/7/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGTermsOfUseController.h"

@interface MGTermsOfUseController()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MGTermsOfUseController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _textView.contentOffset = CGPointZero;
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Terms of Use";

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


@end
