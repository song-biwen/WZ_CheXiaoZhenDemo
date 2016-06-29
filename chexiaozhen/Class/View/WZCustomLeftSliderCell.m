//
//  WZCustomLeftSliderCell.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/27.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZCustomLeftSliderCell.h"

@interface WZCustomLeftSliderCell ()

//发布时间
@property (weak, nonatomic) IBOutlet UILabel *publish_label;


//品牌图标
@property (weak, nonatomic) IBOutlet UIImageView *corver_imageView;


//维修、保养
@property (weak, nonatomic) IBOutlet UILabel *type_label;


//标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

//内容
@property (weak, nonatomic) IBOutlet UILabel *content_label;

//预约时间
@property (weak, nonatomic) IBOutlet UILabel *book_label;


//顶部视图
@property (weak, nonatomic) IBOutlet UIView *top_view;

//顶部视图右边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_rightConstraint;


@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation WZCustomLeftSliderCell

+ (instancetype)cell {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WZCustomLeftSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    self.button.userInteractionEnabled = NO;
    [self setupTopView];
}

//设置顶部视图
- (void)setupTopView {
    
    //添加左滑手势
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.top_view addGestureRecognizer:swipLeft];
    
    //添加右滑手势
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.top_view addGestureRecognizer:swipRight];
    
}

/**滑动手势*/
-(void)swipAction:(UISwipeGestureRecognizer *)sender
{
    //左滑
    if(sender.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        if(_isOpen)
            return;
        self.topView_rightConstraint.constant = 80;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
        _isOpen=YES;
    }
    //右滑
    else if(sender.direction==UISwipeGestureRecognizerDirectionRight)
    {
        if(!_isOpen)
            return;
        self.topView_rightConstraint.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
        _isOpen=NO;
    }
}
@end
