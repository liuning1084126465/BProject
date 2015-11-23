//
//  LyricManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

// 用来存放歌词
@property (nonatomic, strong) NSArray *allLyricArray;
+ (instancetype)sharedManager;

- (void)loadLyricWith:(NSString *)lyricStr;

// 根据播放时间获取到播放到该播放的歌词的索引
- (NSInteger)indexWith:(NSTimeInterval)time;
@end
