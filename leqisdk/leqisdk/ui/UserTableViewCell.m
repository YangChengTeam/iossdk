//
//  UserTableViewCell.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/17.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "UserTableViewCell.h"
#import "BaseViewController.h"
@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.lbNickname  = [UILabel new];
        self.lbNickname.textColor = kColorWithHex(0x333333);
        self.lbNickname.font = [UIFont systemFontOfSize: 16];
        self.lbNickname.frame = CGRectMake(14, 0, self.frame.size.width - 10, self.frame.size.height-4);
        [self addSubview:self.lbNickname];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
