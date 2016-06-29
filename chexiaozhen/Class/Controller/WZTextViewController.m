//
//  WZTextViewController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/27.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZTextViewController.h"

#import "WZTextView.h"
@interface WZTextViewController ()
<UITextViewDelegate>


//@property (strong, nonatomic) WZTextView *textView;

@property (weak, nonatomic) IBOutlet WZTextView *content_textview;
@end

@implementation WZTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.content_textview.placeholder = @"请输入内容";
    self.content_textview.text = @"";
    self.content_textview.delegate = self;
    
    [self updateTextViewFrame:[self textViewHeight]];
}

- (CGFloat)textViewHeight {
    return [self.content_textview sizeThatFits:CGSizeMake(self.content_textview.frame.size.width, MAXFLOAT)].height;
}

- (void)updateTextViewFrame:(CGFloat)height {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.textView_heightConstraint.constant = height;
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self updateTextViewFrame:[self textViewHeight]];
}

@end
