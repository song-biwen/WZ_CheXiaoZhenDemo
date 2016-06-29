//
//  WZEditorViewController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/27.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZEditorViewController.h"
#import "WZCustomLeftSliderCell.h"
#import "WZTextViewCell.h"


@interface WZEditorViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WZEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id tableCell = nil;
    if (indexPath.row % 3 == 0) {
        WZCustomLeftSliderCell *cell = [WZCustomLeftSliderCell cellWithTableView:tableView];
        tableCell = cell;
    }else {
        
        WZTextViewCell *cell = [WZTextViewCell cellWithTableView:tableView];
        if (indexPath.row % 3 == 1) {
            cell.title = @"内容描述";
        }else {
            cell.title = @"公司介绍";
        }
        
        tableCell = cell;
    }
    
    
    return tableCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 3 == 0) {
        return 125;
    }else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
