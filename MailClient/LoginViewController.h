//
//  ViewController.h
//  MailClient
//
//  Created by Roxane Amory on 10.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>
#import "LoginViewControllerModel.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, atomic) IBOutlet UITextField *emailTextField;

@property (weak, atomic) IBOutlet UITextField *passwordTextField;


@end

