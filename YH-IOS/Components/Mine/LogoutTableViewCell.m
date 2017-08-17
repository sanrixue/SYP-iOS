//
//  LogoutTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "LogoutTableViewCell.h"

@implementation LogoutTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}


-(void)layoutViews {
    
    self.logoutButton = [[UIButton alloc]init];
    [self addSubview:self.logoutButton];
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.logoutButton setTitleColor:[UIColor colorWithHexString:@"#f57658"] forState:UIControlStateNormal];
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    
    [self layoutUI];
}

- (void) layoutUI {
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
