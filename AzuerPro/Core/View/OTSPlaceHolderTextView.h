//
//  UIPlaceHolderTextView.h
//  OneStore
//
//  Created by xiao jie on 13-12-13.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSPlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
