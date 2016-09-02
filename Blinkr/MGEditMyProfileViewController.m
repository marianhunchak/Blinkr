//
//  MGEditMyProfileViewController.m
//  S3XTesla
//
//  Created by Орест on 01.06.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGEditMyProfileViewController.h"
#import "MGNetworkManager.h"
#import "SevenSwitch.h"
#import "MGFetchUserInfo.h"
#import "SAMHUDView.h"
#import "NSData+Base64.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"
#import "MGFileManager.h"

@interface MGEditMyProfileViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *licensePlateTextField;
@property (weak, nonatomic) IBOutlet UITextField *facebookLinkTextField;
@property (weak, nonatomic) IBOutlet UITextField *teslaModelTextField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) IBOutletCollection(SevenSwitch) NSArray *switchesArray;

@property (weak, nonatomic) IBOutlet SevenSwitch *showEmailSwitch;
@property (weak, nonatomic) IBOutlet SevenSwitch *showPhoneSwitch;
@property (weak, nonatomic) IBOutlet SevenSwitch *showLicensePlateSwitch;
@property (weak, nonatomic) IBOutlet SevenSwitch *showFacebookUrlSwitch;


@end


@implementation MGEditMyProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setProperty];
    
    
    self.navigationItem.title = @"Edit Profile";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100.f;
    
    for (SevenSwitch *lSwitch in _switchesArray) {
        lSwitch.onLabel.textColor = [UIColor whiteColor];
        lSwitch.onLabel.text = @"Show";
        lSwitch.offLabel.text = @"Hide";
    }
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnPresed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    _bioTextView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:self.view.window];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillHide:(NSNotification *)n {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}


- (void) setProperty {
    
    Profile *lProfile = [Profile MR_findFirst];
    
    self.emailTextField.text = lProfile.email;
    self.nameTextField.text = lProfile.name;
    self.phoneNumberTextField.text = lProfile.phone_number;
    self.facebookLinkTextField.text = lProfile.facebook_link;
    self.teslaModelTextField.text = lProfile.car_model;
    self.licensePlateTextField.text = lProfile.license_plate;
    self.bioTextView.text = lProfile.bio;
    _showEmailSwitch.on = [lProfile.show_email boolValue];
    _showPhoneSwitch.on = [lProfile.show_phone_number boolValue];
    _showLicensePlateSwitch.on = [lProfile.show_license_plate boolValue];
    _showFacebookUrlSwitch.on = [lProfile.show_facebook_link boolValue];
    
    if ([lProfile.pictureURL hasPrefix:@"http"]) {
        
        __weak typeof(self) weakSelf = self;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lProfile.pictureURL]];
        
        [self.profileImage setImageWithURLRequest:request placeholderImage:nil
         
                                          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                              
                                              weakSelf.profileImage.image = image;
                                              lProfile.pictureURL = [MGFileManager writeProfileImageToDocuments:image];
                                              
                                          } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                              
                                          }];
        
    } else {
        
        self.profileImage.image = [MGFileManager getProfileImageFromDocuments];
    }
    [_bioTextView scrollRangeToVisible:NSMakeRange(0, 0)];
 
}


#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return self.view.frame.size.height / 2.5f;
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, 9999.f)];
    CGRect newFrame = textView.frame;
    
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    CGFloat delta = newFrame.size.height - textView.frame.size.height;
    
    textView.frame = newFrame;
    
    CGRect cellFrame = cell.frame;
    
    cellFrame.size.height += delta;
    
    cell.frame = cellFrame;
    
    
    if (delta != 0) {
        
        [self.tableView setContentSize:CGSizeMake(self.tableView.contentSize.width,
                                                  self.tableView.contentSize.height + delta)];

    }
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 2) {
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Private methods 

- (BOOL)validateEnteredInfo {
    
    NSString *alertTitle = @"Warning";
    NSString *alertMessage = @"";
    
    if ([_nameTextField.text isEqualToString:@""] || _nameTextField.text.length > 50) {
        alertMessage = @"Name field can`t be empty or longer than 50 characters";
    } else if (![self isValidEmail:_emailTextField.text]) {
        alertMessage = @"Please enter valid email";
    } else if (_phoneNumberTextField.text.length > 30) {
        alertMessage = @"Phone number field can`t be longer than 30 characters";
    } else if (_teslaModelTextField.text.length > 40) {
        alertMessage = @"Car model field can`t be longer than 40 characters";
    } else if (_licensePlateTextField.text.length > 30) {
        alertMessage = @"License plate field can`t be longer than 30 characters";
    } else if (_bioTextView.text.length > 2000) {
        alertMessage = @"License plate field can`t be longer than 2000 characters";
    }
    
    if ([alertMessage isEqualToString:@""]) {
        return YES;
    } else {
    
        UIAlertDialog *alerDialog = [[UIAlertDialog alloc] initWithStyle:UIAlertDialogStyleAlert title:alertTitle andMessage:alertMessage];
        [alerDialog addButtonWithTitle:@"OK" andHandler:nil];
        [alerDialog showInViewController:self];

        return NO;
    }
    
}

-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark - Actions

- (void)saveBtnPresed:(UIBarButtonItem *) sender {
    
    if (![self validateEnteredInfo]) {
        return;
    }
    
    NSDictionary *json = @{
                           @"name":_nameTextField.text,
                           @"email":_emailTextField.text,
                           @"phone_number":_phoneNumberTextField.text,
                           @"car_model":_teslaModelTextField.text,
                           @"license_plate":_licensePlateTextField.text,
                           @"bio":_bioTextView.text,
                           @"show_license_plate":@(_showLicensePlateSwitch.on),
                           @"show_email":@(_showEmailSwitch.on),
                           @"show_facebook_link":@(_showFacebookUrlSwitch.on),
                           @"show_phone_number":@(_showPhoneSwitch.on)};
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:json];
    
    if (_profileImage.image != nil && ![_profileImage.image isEqual:[MGFileManager getProfileImageFromDocuments]]) {
        NSData *imageData = UIImageJPEGRepresentation(_profileImage.image, 0.5);
        NSString *imageDataEncodedeString = [imageData base64EncodedString];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        
        NSString *imageName = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDictionary *dictWihImageParams = @{@"filename":[imageName stringByAppendingString:@".jpg"],
                                             @"content":imageDataEncodedeString,
                                             @"content_type":@"image/jpg"};
        [params setObject:dictWihImageParams forKey:@"image"];
    }
    
    
    SAMHUDView *hd = [[SAMHUDView alloc] initWithTitle:@"Saving..." loading:YES];
    [hd show];
    
    [MGNetworkManager updateMyProfileWithID:_userInfo.userID parameters:params withCompletion:^(id object, NSError *error) {
        
        if (object) {
            
            [hd completeAndDismissWithTitle:@"Saved"];
            [MGFileManager writeProfileImageToDocuments:self.profileImage.image];
            [Profile updateProfileWithDict:params];
            [[NSNotificationCenter defaultCenter] postNotificationName:PROFILE_UPDATED_KEY object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [hd failAndDismissWithTitle:@"Something went wrong"];
        }
        
    }];
}

- (void)handleTapGesture: (UITapGestureRecognizer *) sender {
    
    [self.view endEditing:YES];
   
    
}

- (IBAction)addImage:(UIButton *)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take a photo",
                            @"Choose from library",
                            nil];
    [popup showInView:self.view];
    
}

@end
