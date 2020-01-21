//
//  MyTableViewCell.m
//  MailClient
//
//  Created by Roxane Amory on 11.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.messageRenderingOperation cancel];
    self.detailTextLabel.text = @" ";
}


@end
