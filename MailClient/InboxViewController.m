//
//  MyTableViewController.m
//  MailClient
//
//  Created by Roxane Amory on 11.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import "InboxViewController.h"

@interface InboxViewController ()

@end

static const int kNumberOfMessages = 20;

@implementation InboxViewController

- (IBAction)SentEmailSegue:(id)sender {
    [self performSegueWithIdentifier:@"SentEmail" sender:nil];
}

- (void)refreshMail {
    [self fetchEmail:kNumberOfMessages];
    messageArray = nil;
    messagePreviews = [NSMutableDictionary new];
    messageCount = 0;
    self.totalNumberOfInboxMessages = -1;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshMail) forControlEvents: UIControlEventValueChanged];
    self.refreshControl.tintColor = UIColor.cyanColor;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _isLoading = NO;
    _loadMoreActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    [self initIMAPSession];
    [self refreshMail];
    [self.tableView reloadData];
}

-(void)initIMAPSession {
    _imapSession = [[MCOIMAPSession alloc] init];
    _imapSession.hostname = @"imap.gmail.com";
    [_imapSession setConnectionType:MCOConnectionTypeTLS];
    [_imapSession setPort: 993];
    [_imapSession setUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
    [_imapSession setPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    [_imapSession setConnectionType:MCOConnectionTypeTLS];
}

-(void)fetchEmail:(NSUInteger)nMessages {
    [appDelegate showLoading];
    self.isLoading = YES;
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
    (MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
     MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
     MCOIMAPMessagesRequestKindFlags | MCOIMAPMessagesRequestKindGmailThreadID);
    
    NSString *inboxFolder = @"INBOX";
    MCOIMAPFolderInfoOperation *inboxFolderInfo = [self.imapSession folderInfoOperation:inboxFolder];
    
    [inboxFolderInfo start:^(NSError *error, MCOIMAPFolderInfo *info) {
        BOOL totalNumberOfMessagesDidChange =
        self->_totalNumberOfInboxMessages != [info messageCount];
        
        self->_totalNumberOfInboxMessages = [info messageCount];
        
        NSUInteger numberOfMessagesToLoad =
        MIN(self.totalNumberOfInboxMessages, nMessages);
        
        MCORange fetchRange;
        
        // If total number of messages did not change since last fetch,
        // assume nothing was deleted since our last fetch and just
        // fetch what we don't have
        if (!totalNumberOfMessagesDidChange && self->messageArray.count)
        {
            numberOfMessagesToLoad -= self->messageArray.count;
            
            fetchRange =
            MCORangeMake(self.totalNumberOfInboxMessages -
                         self->messageArray.count -
                         (numberOfMessagesToLoad - 1),
                         (numberOfMessagesToLoad - 1));
        }
        // Else just fetch the last N messages
        else
        {
            fetchRange =
            MCORangeMake(self.totalNumberOfInboxMessages -
                         (numberOfMessagesToLoad - 1),
                         (numberOfMessagesToLoad - 1));
        }
        
        self->_imapMessagesFetchOp = [self->_imapSession fetchMessagesByNumberOperationWithFolder:inboxFolder
                                                                                      requestKind:requestKind
                                                                                          numbers:
                                      [MCOIndexSet indexSetWithRange:fetchRange]];
        
        [self.imapMessagesFetchOp setProgress:^(unsigned int progress) {
            NSLog(@"Progress: %u of %lu", progress, (unsigned long)numberOfMessagesToLoad);
        }];
        
        [self.imapMessagesFetchOp start: ^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages) {
            [self->appDelegate hideLoading];
            self.isLoading = NO;
            if (messages.count > 0)
            {
                NSLog(@"fetched all messages.");
                NSSortDescriptor *sort =
                [NSSortDescriptor sortDescriptorWithKey:@"header.date" ascending:NO];
                
                NSMutableArray *combinedMessages =
                [NSMutableArray arrayWithArray:messages];
                [combinedMessages addObjectsFromArray:self->messageArray];
                
                self->messageArray = [combinedMessages sortedArrayUsingDescriptors:@[sort]];
                [self filterMailAccordingToThreadID];
                
            }
            else {
                [self showAlertView:[error localizedDescription]];
            }
        }];
    }];
}

-(void)filterMailAccordingToThreadID {
    filterDict = [[NSMutableDictionary alloc]init];
    NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:messageArray];
    for (int i = 0; i < temp.count; i++)
    {
        MCOIMAPMessage *messageI = temp[i];
        [filterDict setObject:[[NSMutableArray alloc]init] forKey:[NSString stringWithFormat:@"%d",i]];
        [[filterDict objectForKey:[NSString stringWithFormat:@"%d",i]] addObject:messageI];
        for (int j = i; j < temp.count; j++)
        {
            MCOIMAPMessage *messageJ = temp[j];
            if ((messageI.gmailThreadID == messageJ.gmailThreadID) &&(i != j)) {
                [[filterDict objectForKey:[NSString stringWithFormat:@"%d",i]] addObject:messageJ];
                [temp removeObjectAtIndex:j];
            }
        }
    }
    [self.tableView reloadData];
}

-(void)showAlertView:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
    {
        if (self.totalNumberOfInboxMessages >= 0)
            return 1;
        
        return 0;
    }
    
    return [filterDict allKeys].count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
            MCOIMAPMessage *message = [[filterDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] objectAtIndex:0];
            
            UILabel *titleLabel = [cell viewWithTag:1];
            UILabel *subtitleLabel = [cell viewWithTag:2];
            
            titleLabel.text = message.header.subject;
            
//            NSLog(@"thread ID %llu",message.gmailThreadID);
//            NSLog(@"message  ID %llu",message.gmailMessageID);
            
            NSString *uidKey = [NSString stringWithFormat:@"%d", message.uid];
            NSString *cachedPreview = messagePreviews[uidKey];
            
            if (cachedPreview) {
                subtitleLabel.text = cachedPreview;
            }
            else {
                cell.messageRenderingOperation = [self.imapSession plainTextBodyRenderingOperationWithMessage:message folder:@"INBOX"];
                
                [cell.messageRenderingOperation start:^(NSString * plainTextBodyString, NSError * error) {
                    subtitleLabel.text = plainTextBodyString;
                    cell.messageRenderingOperation = nil;
                    self->messagePreviews[uidKey] = plainTextBodyString;
                }];
            }
            return cell;
            break;
        }
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxStatusCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InboxStatusCell"];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            }
            if (messageArray.count < self.totalNumberOfInboxMessages) {
                cell.textLabel.text =
                [NSString stringWithFormat:@"Load %lu more",
                 MIN(self.totalNumberOfInboxMessages - messageArray.count,
                     kNumberOfMessages)];
            }
            else
                cell.textLabel.text = nil;
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld message(s)", (long)self.totalNumberOfInboxMessages];
            
            cell.accessoryView = self.loadMoreActivityView;
            
            if (self.isLoading)
                [self.loadMoreActivityView startAnimating];
            else
                [self.loadMoreActivityView stopAnimating];
            
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            [self performSegueWithIdentifier:@"showMessage" sender:[filterDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
            break;
        }
        case 1: {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (!self.isLoading && messageArray.count < self.totalNumberOfInboxMessages) {
                [self fetchEmail:messageArray.count + kNumberOfMessages];
                cell.accessoryView = self.loadMoreActivityView;
                [self.loadMoreActivityView startAnimating];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMessage"]) {
        MessageViewController *vc = [segue destinationViewController];
        vc.folder = @"INBOX";
        vc.arrayOfMessages = [[NSMutableArray alloc]initWithArray: (NSMutableArray*)sender];
        vc.imapSession = self.imapSession;
        vc.messagePreviews = [[NSMutableDictionary alloc]initWithDictionary:messagePreviews];
    }
}



@end
