//
//  MessageSentViewController.h
//  MailClient
//
//  Created by Roxane Amory on 21.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageSentViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
- (IBAction)sentEmailButtonPressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
