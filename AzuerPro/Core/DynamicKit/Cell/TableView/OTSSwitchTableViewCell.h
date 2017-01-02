//
//  OTSSwitchTableViewCell.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/12.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>

@interface OTSSwitchTableViewCell : OTSTableViewCell

@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UISwitch *switchButton;

@end
