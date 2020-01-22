//
//  LoginViewControllerModel.h
//  MailClient
//
//  Created by Roxane Amory on 23.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewControllerModel : NSObject

-(BOOL)isValidEmail:(NSString *)emailString;

@end

NS_ASSUME_NONNULL_END
