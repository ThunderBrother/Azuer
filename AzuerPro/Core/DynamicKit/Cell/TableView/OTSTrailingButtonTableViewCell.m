//
//  OTSTrailingButtonTableViewCell.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/12.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTrailingButtonTableViewCell.h"
#import "OTSTableViewItem.h"

@interface OTSTrailingButtonTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@end

@implementation OTSTrailingButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (CGFloat)heightForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return .0;
    }
    
    OTSTableViewItem *item = aData;
    NSString *title = item.titleAttribute.title;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect textRect = [title boundingRectWithSize:CGSizeMake(UI_CURRENT_SCREEN_WIDTH - 30.0, .0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:OTSSmallFont, NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    
    return 15.0 + textRect.size.height + 30.0;
}

- (IBAction)didPressActionButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:(id)self.superview.superview didSelectRowAtIndexPath:self.indexPath];
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == self.contentView) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return;
    }
    
    OTSTableViewItem *item = aData;
    self.titleLabel.text = item.titleAttribute.title;
    [self.actionButton setTitle:item.subTitleAttribute.title forState:UIControlStateNormal];
}

@end
