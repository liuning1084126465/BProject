//
//  PlayerManger.m
//  MusicPlayer
//
//  Created by liuning on 15/11/5.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import "PlayerManger.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerManger ()
// 播放器->全局唯一，因为如果有两个avplayer的话，就会同时播放两个音乐
@property (nonatomic, strong) AVPlayer *player;
// 计时器
@property (nonatomic, strong) NSTimer *timer;
@end

static PlayerManger *manger = nil;

@implementation PlayerManger

// 用单例的方式创建，保证，每一次只播放一个音乐
+ (PlayerManger *)sharedManger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[PlayerManger alloc] init];
    });
    return manger;
}
/**
 *  根据MP3网址播放
 *
 *  @param urlString 网址
 */
- (void)playWithUrlString:(NSString *)urlString {
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    // 替换原来播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:item];
    // 对item添加观察者
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 懒加载
- (AVPlayer *)player {
    if (_player == nil) {
        _player = [AVPlayer new];
    }
    return _player;
}

#pragma mark 观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    NSLog(@"keyPath = %@,  change = %@", keyPath, change);
    switch (status) {
        case AVPlayerItemStatusUnknown:
            NSLog(@"没有对应的网址");
            break;
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"开始播放");
            // 开始播放放到观察者中
            // 先暂停将timer销毁
            [self pause];
            [self play];
            _isPlaying = YES;
            break;
        default:
            break;
    }
}

#pragma mark 播放
- (void)play {
    // 如果正在播放的话，就不播放了
//    if (_isPlaying) {
//        return;
//    }
    [self.player play];
    // 开始播放后标记一下
    _isPlaying = YES;
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
}

- (void)playingWithSeconds {
    NSLog(@"%lld", self.player.currentTime.value / self.player.currentTime.timescale);
    // 计算一下播放器现在播放的秒数
    NSTimeInterval time = self.player.currentTime.value / self.player.currentTime.timescale;
    if (_delegate && [_delegate respondsToSelector:@selector(playerPlayingWithTime:)]) {
        [_delegate playerPlayingWithTime:time];
    }
}

#pragma mark 暂停
- (void)pause {
    [self.player pause];
    // 暂停播放后标记一下
    _isPlaying = NO;
    
    // 暂停就销毁计时器
    [self.timer invalidate];
}

#pragma mark 改变进度条方法
- (void)seekToTime:(NSTimeInterval)time {
    // 先暂停
    [self pause];
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            // 拖拽成功后在播放
            [self play];
        }
    }];
}

#pragma mark 初始化并添加观察者
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加通知中心，当self发出AVPlayerItemDidPlayToEndTimeNotification时触发playerDidPlayEnd事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)playerDidPlayEnd:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        // 接收到item播放结束后，让代理去干一件事情，代理会怎样干，播放区不需要知道
        [self.delegate playerDidPlayEnd];
    }
}

// 改变音量
- (void)changeToVolume:(CGFloat)volume {
    self.player.volume = volume;
}

// 用来访问avplayer的音量
- (CGFloat)volume {
    return self.player.volume;
}
@end
