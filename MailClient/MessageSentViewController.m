//
//  MessageSentViewController.m
//  MailClient
//
//  Created by Roxane Amory on 21.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import "MessageSentViewController.h"

@interface MessageSentViewController ()

@end

@implementation MessageSentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toTextField.delegate = self;
    self.subjectTextField.delegate = self;
}

- (IBAction)sentEmailButtonPressed:(id)sender {
    MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.hostname = @"smtp.gmail.com";
    smtpSession.port = 465;
    smtpSession.username = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    smtpSession.password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    smtpSession.connectionType = MCOConnectionTypeTLS;
    
    MCOMessageBuilder * builder = [[MCOMessageBuilder alloc] init];
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:nil mailbox:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]]];
    NSMutableArray *to = [[NSMutableArray alloc] init];
    NSArray *RECIPIENTS = [_toTextField.text componentsSeparatedByString:@","];
    for(NSString *toAddress in RECIPIENTS) {
        MCOAddress *newAddress = [MCOAddress addressWithMailbox:toAddress];
        [to addObject:newAddress];
    }
    [[builder header] setTo:to];
    [[builder header] setSubject:_subjectTextField.text];
    [builder setHTMLBody:[NSString stringWithFormat:@"<p>%@</p>", _msgTextView.text]];
    NSData * rfc822Data = [builder data];
    MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:rfc822Data];
    [sendOperation start:^(NSError *error) {
        if(error) {
            NSLog(@"%@ Error sending email:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"email"], error);
        } else {
            NSLog(@"%@ Successfully sent email!", [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
        }
    }];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
