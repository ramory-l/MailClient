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

@implementation LoginViewController {
    LoginViewControllerModel *model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[LoginViewControllerModel alloc] init];
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (IBAction)loginButtonPressed:(id)sender {
    if ((_emailTextField.text.length > 0) && ([model isValidEmail:_emailTextField.text]) && (_passwordTextField.text.length > 0)) {
        [[NSUserDefaults standardUserDefaults] setObject:_emailTextField.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _emailTextField.text = @"";
        _passwordTextField.text = @"";
        [self performSegueWithIdentifier:@"loginToInbox" sender:nil];
    }
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
