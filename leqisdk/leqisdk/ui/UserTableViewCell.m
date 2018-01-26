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
        
        [self addSubview:self.lbNickname];
        
        self.btnClose =  [UIButton new];
        [self.btnClose setImage:[UIImage imageNamed:@"account_close" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.btnClose addTarget:self action:@selector(delInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.btnClose];
    }
    return self;
}

- (void)delInfo:(id)sender {
    if(self.delegate){
        [self.delegate delInfo:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
