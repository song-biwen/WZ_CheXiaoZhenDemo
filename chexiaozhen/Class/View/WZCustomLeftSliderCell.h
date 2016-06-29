//
//  WZCustomLeftSliderCell.h
//  chexiaozhen
//
//  Created by songbiwen on 16/6/27.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZCustomLeftSliderCell : UITableViewCell

+ (instancetype)cell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**标记左滑菜单是否打开*/
@property(nonatomic,assign,readonly)BOOL isOpen;

@end
