//
//  MyTableViewCell.h
//  MailClient
//
//  Created by Roxane Amory on 11.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) MCOIMAPMessageRenderingOperation *messageRenderingOperation;

@end
