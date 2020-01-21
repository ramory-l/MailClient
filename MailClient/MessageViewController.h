//
//  MessageViewController.h
//  MailClient
//
//  Created by Roxane Amory on 20.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet UITextView *txtViewMailBody;

@property (nonatomic, strong) MCOIMAPMessage * message;
@property (nonatomic, strong) NSMutableDictionary *dictMailInfo, *messagePreviews;
@property (nonatomic, strong) MCOIMAPSession * imapSession;
@property (nonatomic, strong) NSString       * folder;
@property (nonatomic, strong) NSMutableArray *arrayOfMessages;

@end

NS_ASSUME_NONNULL_END
