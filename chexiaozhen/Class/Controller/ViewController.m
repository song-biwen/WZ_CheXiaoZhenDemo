//
//  ViewController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/27.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WZCustomLeftSliderController.h" //自定义侧滑
#import "WZTextViewController.h" //textView动态计算高度
#import "WZEditorViewController.h" //tablevIew嵌套textView
#import "WZZBarViewController.h" //二维码生成
#import "WZZbarScanController.h" //二维码扫描
#import "WZVoice2ViewController.h" //音频
#import "WZVideoController.h" //视频
#import "WZKeFuViewController.h"//微客服
#import "WZCityLocationController.h" //城市定位



#define KContent1 @"文本转语言"
#define KContent2 @"侧滑自定义"
#define KContent3 @"textView动态计算高度"
#define KContent4 @"textView动态计算高度与tablevIew混合使用(未完成)"
#define KContent5 @"二维码生成"
#define KContent6 @"二维码扫描"
#define KContent7 @"音频"
#define KContent8 @"视频"
#define KContent9 @"微客服"
#define KContent10 @"城市定位"

@interface ViewController ()
<UITableViewDelegate, UITableViewDataSource>
/*将文本转为语言*/
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSArray *array;

/*tablevIew*/
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将文本转为语言
    self.array = @[
                   @"最是一年春好处,绝胜烟柳满皇都",
                   @"陌上花开,可缓缓归矣",
                   @"沾衣欲湿杏花雨，吹面不寒杨柳风",
                   @"竹外桃花三两枝，春江水暖鸭先知",
                   @"几处早莺争暖树,谁家新燕啄春泥",
                   @"乱花渐欲迷人眼,浅草才能没马蹄"
                   ];
    
    self.synthesizer = [[AVSpeechSynthesizer alloc]init];
    
    
    //tablevIew
    [self.view addSubview:self.tableView];
    self.dataSource = [NSArray arrayWithObjects:
                       KContent1,
                       KContent2,
                       KContent3,
                       KContent4,
                       KContent5,
                       KContent6,
                       KContent7,
                       KContent8,
                       KContent9,
                       KContent10,
                       nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *content = self.dataSource[indexPath.row];
    if ([content isEqualToString:KContent1]) {
        //文本转语言
        [self saySomething];
    }
    
    if ([content isEqualToString:KContent2]) {
        //侧滑自定义
        WZCustomLeftSliderController *vc = [[WZCustomLeftSliderController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([content isEqualToString:KContent3]) {
        //textView动态计算高度
        WZTextViewController *vc = [[WZTextViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([content isEqualToString:KContent4]) {
        //textView动态计算高度与tablevIew混合使用(未完成)
        WZEditorViewController *vc = [[WZEditorViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([content isEqualToString:KContent5]) {
        //二维码生成
        WZZBarViewController *vc = [[WZZBarViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([content isEqualToString:KContent6]) {
        //二维码扫描
        WZZbarScanController *vc = [[WZZbarScanController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([content isEqualToString:KContent7]) {
        //音频
        WZVoice2ViewController *vc = [[WZVoice2ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([content isEqualToString:KContent8]) {
        //视频
        WZVideoController *vc = [[WZVideoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([content isEqualToString:KContent9]) {
        //微客服
        WZKeFuViewController *vc = [[WZKeFuViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([content isEqualToString:KContent10]) {
        //城市定位
        WZCityLocationController *vc = [[WZCityLocationController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

/** 文本转语言 */
- (void)saySomething {
    
    for (int i = 0; i < self.array.count; i ++) {
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:self.array[i]];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        utterance.rate = 0.4;
        utterance.pitchMultiplier = 0.8;
        utterance.postUtteranceDelay = 0.1;
        [self.synthesizer speakUtterance:utterance];
        
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}
@end
