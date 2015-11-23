//
//  LyricModel.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject
// 歌词播放时间
@property (nonatomic, assign) NSTimeInterval time;
// 歌词内容
@property (nonatomic, strong) NSString *lyricContext;

- (instancetype)initWithTime:(NSTimeInterval)time andWithLyric:(NSString *)lyricContext;
@end
