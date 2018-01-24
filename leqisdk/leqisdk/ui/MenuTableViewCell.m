//
//  MenuTableViewCell.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "BaseViewController.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.lbMenuName  = [UILabel new];
        self.lbMenuName.textColor = kColorWithHex(0x333333);
        self.lbMenuName.font = [UIFont systemFontOfSize: 15];
        self.lbMenuName.frame = CGRectMake(14, 0, self.frame.size.width - 20, self.frame.size.height-4);
        [self addSubview:self.lbMenuName];
        
        self.ivArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil]];
        self.ivArrow.frame = CGRectMake(self.frame.size.width - 28, 12, 18, 18);
        [self addSubview:self.ivArrow];
        
        self.sAutoLogin = [UISwitch new];
        [self addSubview:self.sAutoLogin];
        
        self.lbSel  = [UILabel new];
        self.lbSel.textColor = kColorWithHex(0xEA351F);
        self.lbSel.font = [UIFont systemFontOfSize: 12];
        [self addSubview:self.lbSel];
    }
       
       
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
