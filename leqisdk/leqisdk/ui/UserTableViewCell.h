//
//  UserTableViewCell.h
//  leqisdk
//
//  Created by zhangkai on 2018/1/17.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserTableViewCellDelegate <NSObject>
- (void)delInfo:(id)sender;
@end

@interface UserTableViewCell : UITableViewCell

@property UILabel *lbNickname;
@property UIButton *btnClose;
@property (nonatomic,assign) id<UserTableViewCellDelegate> delegate;
@end



