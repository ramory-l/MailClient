//
//  MyTableViewController.h
//  MailClient
//
//  Created by Roxane Amory on 11.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MailCore/MailCore.h>
#import "MyTableViewCell.h"
#import "MessageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InboxViewController : UITableViewController {
    AppDelegate *appDelegate;
    NSArray *messageArray;
    NSMutableDictionary *filterDict;
    NSMutableDictionary *messagePreviews;
    int messageCount;
}

@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic) MCOIMAPSession *imapSession;
@property (nonatomic) NSInteger totalNumberOfInboxMessages;
@property (nonatomic, strong) MCOIMAPFetchMessagesOperation *imapMessagesFetchOp;

@end

NS_ASSUME_NONNULL_END
