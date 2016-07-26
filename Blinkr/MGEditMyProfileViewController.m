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
    
    self.emailTextField.text = _userInfo.email;
    self.nameTextField.text = _userInfo.name;
    self.phoneNumberTextField.text = _userInfo.phoneNumber;
    self.facebookLinkTextField.text = _userInfo.facebookLink;
    self.profileImage.image = _userImage;
    self.teslaModelTextField.text = _userInfo.teslaModel;
    self.licensePlateTextField.text = _userInfo.licensePlate;
    self.bioTextView.text = _userInfo.bio;
    _showEmailSwitch.on = _userInfo.showEmail;
    _showPhoneSwitch.on = _userInfo.showPhoneNumber;
    _showLicensePlateSwitch.on = _userInfo.showLicensePlate;
    _showFacebookUrlSwitch.on = _userInfo.showFacebookLink;
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
    
    NSLog(@"Content size before = %@" , NSStringFromCGSize(self.tableView.contentSize));
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
//    [self.profileImg bringSubviewToFront:self.selectImageBtn];
    self.profileImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - API put


#pragma mark - Actions

- (void)saveBtnPresed:(UIBarButtonItem *) sender {
    
    NSDictionary *json = @{
                           @"name":_nameTextField.text,
                           @"email":_emailTextField.text,
                           @"phone_number":_phoneNumberTextField.text,
                           @"tesla_model":_teslaModelTextField.text,
                           @"license_plate":_licensePlateTextField.text,
                           @"bio":_bioTextView.text,
                           @"show_license_plate":@(_showLicensePlateSwitch.on),
                           @"show_email":@(_showEmailSwitch.on),
                           @"show_facebook_link":@(_showFacebookUrlSwitch.on),
                           @"show_phone_number":@(_showPhoneSwitch.on)};
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:json];
    
    if (_profileImage.image != nil && [_profileImage.image isEqual:_userImage]) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:PROFILE_UPDATED_KEY object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [hd failAndDismissWithTitle:error.localizedDescription];
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
