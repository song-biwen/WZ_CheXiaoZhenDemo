//
//  WZTextViewCell.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/27.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZTextViewCell.h"
#import "WZTextView.h"

@interface WZTextViewCell ()
//标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

//内容
@property (weak, nonatomic) IBOutlet WZTextView *content_textView;

@end
@implementation WZTextViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WZTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupTextView];
}

- (void)setupTextView {
    self.content_textView.scrollEnabled = NO;
    self.content_textView.showsHorizontalScrollIndicator = NO;
    self.content_textView.showsVerticalScrollIndicator = NO;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.title_label.text = title;
    self.content_textView.placeholder = [NSString stringWithFormat:@"请输入%@",title];
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    // update the UI and the cell size with a delay to allow the cell to load
    self.content_textView.text = text;
    [self performSelector:@selector(textViewDidChange:)
               withObject:self.content_textView
               afterDelay:0.1];
}

- (CGFloat)cellHeight
{
    return [self.content_textView sizeThatFits:CGSizeMake(self.content_textView.frame.size.width, MAXFLOAT)].height + 2*10;
}

- (void)updateTextViewHeight {
    [self textViewDidChange:self.content_textView];
}

#pragma mark - Text View Delegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.expandableTableView.delegate respondsToSelector:@selector(tableView:textViewDidEndEditing:)]) {
        [(id<WZTextViewCellDelegate>)self.expandableTableView.delegate tableView:self.expandableTableView textViewDidEndEditing:self.content_textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([self.expandableTableView.delegate respondsToSelector:@selector(tableView:textViewDidChangeSelection:)]) {
        [(id<WZTextViewCellDelegate>)self.expandableTableView.delegate tableView:self.expandableTableView textViewDidChangeSelection:self.content_textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.expandableTableView.delegate respondsToSelector:@selector(tableView:textView:shouldChangeTextInRange:replacementText:)]) {
        id<WZTextViewCellDelegate> delegate = (id<WZTextViewCellDelegate>)self.expandableTableView.delegate;
        return [delegate tableView:self.expandableTableView
                          textView:textView
           shouldChangeTextInRange:range
                   replacementText:text];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // make sure the cell is at the top
    [self.expandableTableView scrollToRowAtIndexPath:[self.expandableTableView indexPathForCell:self]
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.expandableTableView.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [(id<WZTextViewCellDelegate>)self.expandableTableView.delegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidChange:(UITextView *)theTextView
{
    if ([self.expandableTableView.delegate conformsToProtocol:@protocol(WZTextViewCellDelegate)]) {
        
        id<WZTextViewCellDelegate> delegate = (id<WZTextViewCellDelegate>)self.expandableTableView.delegate;
        NSIndexPath *indexPath = [self.expandableTableView indexPathForCell:self];
        
        // update the text
        _text = self.content_textView.text;
        
        [delegate tableView:self.expandableTableView
                updatedText:_text
                atIndexPath:indexPath];
        
        CGFloat newHeight = [self cellHeight];
        CGFloat oldHeight = [delegate tableView:self.expandableTableView heightForRowAtIndexPath:indexPath];
        if (fabs(newHeight - oldHeight) > 0.01) {
            
            // update the height
            if ([delegate respondsToSelector:@selector(tableView:updatedHeight:atIndexPath:)]) {
                [delegate tableView:self.expandableTableView
                      updatedHeight:newHeight
                        atIndexPath:indexPath];
            }
            
            // refresh the table without closing the keyboard
            [self.expandableTableView beginUpdates];
            [self.expandableTableView endUpdates];
        }
    }
}

@end
