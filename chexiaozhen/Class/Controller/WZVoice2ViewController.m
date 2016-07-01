//
//  WZVoice2ViewController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/30.
//  Copyright © 2016年 songbiwen. All rights reserved.
//
//https://github.com/GreyLove/GreyRecordCafToAMR 音频caf转amr
//http://www.cnblogs.com/ZGSmile/articles/5587231.html 以文件的形式上传服务器

#import "WZVoice2ViewController.h"
#import "RecordManager.h"
#import <AVFoundation/AVFoundation.h>

@interface WZVoice2ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *msg_label;
@property (nonatomic, strong) RecordManager *recordManager;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation WZVoice2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordManager = [RecordManager shareManager];
}

/** 提示语 */
- (void)showMsg:(NSString *)msg {
    self.msg_label.text = msg;
}

#pragma mark - UI事件
/**
 *  点击录音按钮
 *
 *  @param sender 录音按钮
 */
- (IBAction)recordClick:(UIButton *)sender {
    [self showMsg:@"正在录音..."];
    
    [self.recordManager startTalkVoice:@"1"];
}

/**
 *  点击停止按钮
 *
 *  @param sender 停止按钮
 */
- (IBAction)stopClick:(UIButton *)sender {
    
    [self showMsg:@"结束录音..."];
    [self.recordManager writeAuToAmrFile:[self.recordManager stopTalkVoice] callback:^(BOOL success, NSData *amrData) {
        if (success) {
            [self.recordManager playAmrData:amrData];
        }
    }];
}

/**
 *  点击取消按钮
 *
 *  @param sender 取消按钮
 */
- (IBAction)cancelClick:(UIButton *)sender {
    
    [self showMsg:@"取消录音..."];
    [self.recordManager cancelTalkVoice];
    [self.recordManager destroy];
}

/** 
 *  点击播放本地音频按钮
 *
 *  @param sender 播放本地音频按钮
 */

- (IBAction)playLocalAmrClick:(UIButton *)sender {
    
    [self.player play];
}

- (AVAudioPlayer *)player {
    if (_player == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"薛之谦-丑八怪" ofType:@"mp3"];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        [_player prepareToPlay];
    }
    
    return _player;
}
@end
