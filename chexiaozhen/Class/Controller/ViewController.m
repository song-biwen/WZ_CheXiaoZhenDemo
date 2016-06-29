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
#import "WZVoiceViewController.h" //音频

@interface ViewController ()
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[
                   @"最是一年春好处,绝胜烟柳满皇都",
                   @"陌上花开,可缓缓归矣",
                   @"沾衣欲湿杏花雨，吹面不寒杨柳风",
                   @"竹外桃花三两枝，春江水暖鸭先知",
                   @"几处早莺争暖树,谁家新燕啄春泥",
                   @"乱花渐欲迷人眼,浅草才能没马蹄"
                   ];
    
    self.synthesizer = [[AVSpeechSynthesizer alloc]init];
}

//音频提示
- (IBAction)say {
    [self saySomething];
}

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

//自定义侧滑
- (IBAction)customLeftSlider:(id)sender {
    
    WZCustomLeftSliderController *vc = [[WZCustomLeftSliderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//动态计算高度
- (IBAction)textViewHeightAction {
    WZTextViewController *vc = [[WZTextViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)editorAction:(id)sender {
    WZEditorViewController *vc = [[WZEditorViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//黑白二维码WZZBarViewController
- (IBAction)zbarAction {
    
    WZZBarViewController *vc = [[WZZBarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//二维码扫描 WZZbarScanController
- (IBAction)zbarScanAction {
    
    WZZbarScanController *vc = [[WZZbarScanController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//音频WZVoiceViewController
- (IBAction)voiceAction {
    WZVoiceViewController *vc = [[WZVoiceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
