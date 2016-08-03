//
//  MGOptionsController.m
//  Blinkr
//
//  Created by Admin on 8/2/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGOptionsController.h"
#import "MGEditMyProfileViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UIImageView+AFNetworking.h"
#import <MessageUI/MessageUI.h>

@interface MGOptionsController () <MFMailComposeViewControllerDelegate>

@end

@implementation MGOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Options";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        [self showEditProfileController];
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            [self showTermsOfUseController];
        } else {
            [self sendMail];
        }
    } else if (indexPath.section == 2) {
        
        [self logOut];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Private methods

- (void)showEditProfileController {
    
    MGEditMyProfileViewController *editMyProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MGEditMyProfileViewController"];
    //    editMyProfileViewController.userInfo = _userInfo;
    //    editMyProfileViewController.userImage = _profileImage.image;
    [self.navigationController pushViewController:editMyProfileViewController animated:YES];
    
}

- (void)showTermsOfUseController {
    
//    MGEditMyProfileViewController *editMyProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MGEditMyProfileViewController"];
//    [self.navigationController pushViewController:editMyProfileViewController animated:YES];
    
}

- (void)sendMail {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Blinkr support"];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[@"arizemail@gmail.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)logOut {
    
    UIAlertDialog *alerDialog = [[UIAlertDialog alloc] initWithStyle:UIAlertDialogStyleAlert title:nil andMessage:@"Are you sure you want to log out?"];
    
    [alerDialog addButtonWithTitle:@"YES" andHandler:^(NSInteger buttonIndex) {
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }];
    
    [alerDialog addButtonWithTitle:@"NO" andHandler:nil];
    
    [alerDialog showInViewController:self];
    
}


@end