//
//  LoginViewControllerModel.m
//  MailClient
//
//  Created by Roxane Amory on 23.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import "LoginViewControllerModel.h"

@implementation LoginViewControllerModel

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

@end
