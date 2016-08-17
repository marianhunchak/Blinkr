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
#import "Profile.h"
#import "MGTermsOfUseController.h"
#import "SAMHUDView.h"

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
    
    MGEditMyProfileViewController *editMyProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MGEditMyProfileViewController"];;
    [self.navigationController pushViewController:editMyProfileViewController animated:YES];
    
}

- (void)showTermsOfUseController {
    
    MGTermsOfUseController *termsOfUseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MGTermsOfUseController"];
    [self.navigationController pushViewController:termsOfUseVC animated:YES];
    
}

- (void)sendMail {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Blinkr support"];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[@"support@blinkr.me"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)logOut {
    
    UIAlertDialog *alerDialog = [[UIAlertDialog alloc] initWithStyle:UIAlertDialogStyleAlert title:nil andMessage:@"Are you sure you want to log out?"];
    
    __weak typeof(self) weakSelf = self;
    
    [alerDialog addButtonWithTitle:@"YES" andHandler:^(NSInteger buttonIndex) {
        
        
        SAMHUDView *hd = [[SAMHUDView alloc] initWithTitle:@"" loading:YES];
        [hd show];
        
        [MGNetworkManager logOutWithCompletion:^(id object, NSError *error) {
            
            if (!error) {
                
                [FBSDKAccessToken setCurrentAccessToken:nil];
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                [[Profile MR_findFirst] MR_deleteEntity];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                
                [hd completeAndDismissWithTitle:nil];
                
            } else {
                
                UIAlertDialog *alerDialog = [[UIAlertDialog alloc] initWithStyle:UIAlertDialogStyleAlert title:@"Error" andMessage:@"Something went wrong!"];
                
                [alerDialog addButtonWithTitle:@"Close" andHandler:nil];
                
                [alerDialog showInViewController:self];
                
                [hd failAndDismissWithTitle:@"Something went wrong!"];
            }
            
        }];
    }];
    
    [alerDialog addButtonWithTitle:@"NO" andHandler:nil];
    
    [alerDialog showInViewController:self];
    
}


@end
