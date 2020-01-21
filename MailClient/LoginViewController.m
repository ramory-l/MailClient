//
//  ViewController.m
//  MailClient
//
//  Created by Roxane Amory on 10.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (IBAction)loginButtonPressed:(id)sender {
    if ((_emailTextField.text.length > 0) && ([self isValidEmail:_emailTextField.text]) && (_passwordTextField.text.length > 0)) {
        [[NSUserDefaults standardUserDefaults] setObject:_emailTextField.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _emailTextField.text = @"";
        _passwordTextField.text = @"";
        [self performSegueWithIdentifier:@"loginToInbox" sender:nil];
    }
}

-(BOOL)isValidEmail:(NSString *)emailString
{
    if (emailString.length > 0) {
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:emailString];
    }
    return false;
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
