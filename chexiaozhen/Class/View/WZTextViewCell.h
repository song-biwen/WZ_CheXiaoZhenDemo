//
//  WZTextViewCell.h
//  chexiaozhen
//
//  Created by songbiwen on 16/6/27.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WZTextViewCellDelegate <UITableViewDelegate, UITextViewDelegate>

@required
- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)tableView:(UITableView *)tableView textViewDidChangeSelection:(UITextView*)textView;
- (void)tableView:(UITableView *)tableView textViewDidEndEditing:(UITextView*)textView;
@end

@interface WZTextViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) UITableView *expandableTableView;

@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSString *text;

-(void)updateTextViewHeight;
@end
