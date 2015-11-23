//
//  PlayerManger.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerMangerDelegate <NSObject>

// 当播放一首歌结束后，当代理去做的事情
- (void)playerDidPlayEnd;
// 播放中间一直在重复执行的一个方法
- (void)playerPlayingWithTime:(NSTimeInterval)time;

@end

@interface PlayerManger : NSObject
+ (PlayerManger *)sharedManger;

/**
 *  给一个URL，进行播放
 */
- (void)playWithUrlString:(NSString *)urlString;

/**
 *  播放
 */
- (void)play;
/**
 *  暂停
 */
- (void)pause;

/**
 *  播放状态
 */
@property (nonatomic, assign) BOOL isPlaying;

// 设置代理
@property (nonatomic, assign) id <PlayerMangerDelegate> delegate;

// 改变进度
- (void)seekToTime:(NSTimeInterval)time;

// 改变音量
- (void)changeToVolume:(CGFloat)volume;

// 用来访问avplayer的音量
- (CGFloat)volume;
@end
