//
//  WZVideoController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/29.
//  Copyright © 2016年 songbiwen. All rights reserved.
// http://ios.jobbole.com/84146/#comment-90313
//

#import "WZVideoController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WZVideoController ()

@property (weak, nonatomic) IBOutlet UIView *top_view;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerC;
@end

@implementation WZVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.moviePlayerC play];
    [self addNotification];
}

- (void)addNotification {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(moviePlayerPlaybackStateDidChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinishNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}


- (void)moviePlayerPlaybackStateDidChangeNotification:(NSNotification *)notification {
    
    switch (self.moviePlayerC.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayerC.playbackState);
            break;
    }
}


- (void)moviePlayerPlaybackDidFinishNotification:(NSNotification *)notification {
    NSLog(@"播放完成.");
}


- (MPMoviePlayerController *)moviePlayerC {
    
    if (!_moviePlayerC) {
        _moviePlayerC = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0628/577277f29cb1e_wpd.mp4"]];
        CGSize size = self.top_view.frame.size;
        _moviePlayerC.view.frame = CGRectMake(0, 0, size.width, size.height);
        [self.top_view addSubview:_moviePlayerC.view];
    }
    return _moviePlayerC;
}

@end
