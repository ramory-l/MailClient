//
//  MessageViewController.m
//  MailClient
//
//  Created by Roxane Amory on 20.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)setupView
{
    MCOIMAPMessage *message = [_arrayOfMessages objectAtIndex:0];
    _lblFrom.text = [NSString stringWithFormat:@"%@ %@", message.header.from.displayName,  message.header.from.mailbox];
    
    NSString *toString = @"";
    for (int i = 0; i < message.header.to.count; i++)
    {
        NSArray *arr = message.header.to;
        NSLog(@"%@", [[arr objectAtIndex:i] valueForKey:@"displayName"]);

        NSLog(@"%@",[arr description]);

        toString  = [toString stringByAppendingString:[NSString stringWithFormat:@"%@ %@ ",[[arr objectAtIndex:i] valueForKey:@"displayName"],[[arr objectAtIndex:i] valueForKey:@"mailbox"]]];
    }

    _lblTo.text  = [NSString stringWithFormat:@"%@",toString];


    NSString *CCString = @"";
    for (int i = 0; i < message.header.cc.count; i++) {
        NSArray *arr = message.header.cc;

        CCString  = [CCString stringByAppendingString:[NSString stringWithFormat:@"%@ %@ ",[[arr objectAtIndex:i] valueForKey:@"displayName"],[[arr objectAtIndex:i] valueForKey:@"mailbox"]]];
    }
    if (CCString.length)
        _lblTo.text  = [NSString stringWithFormat:@"%@",CCString];


    NSString *bccString = @"";
    for (int i = 0; i < message.header.bcc.count; i++) {

        NSArray *arr = message.header.bcc;

        bccString  = [bccString stringByAppendingString:[NSString stringWithFormat:@"%@ %@",[[arr objectAtIndex:i] valueForKey:@"displayName"],[[arr objectAtIndex:i] valueForKey:@"mailbox"]]];
    }
    if (bccString.length)
        _lblTo.text  = [NSString stringWithFormat:@"%@",bccString];


    NSString *cachedPreview = self.messagePreviews[[NSString stringWithFormat:@"%d", message.uid]];

    if (cachedPreview)
    {

        _txtViewMailBody.text = cachedPreview;
    }
    else
    {
        MCOIMAPMessageRenderingOperation * messageRenderingOperation;
        messageRenderingOperation = [self.imapSession plainTextBodyRenderingOperationWithMessage:message
                                                                                               folder:@"INBOX"];

        [messageRenderingOperation start:^(NSString * plainTextBodyString, NSError * error) {
            self->_txtViewMailBody.text = plainTextBodyString;
        }];
    }
}

@end
