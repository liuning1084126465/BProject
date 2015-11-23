//
//  LyricManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"

@interface LyricManager ()
// 用来存放歌词
@property (nonatomic, strong) NSMutableArray *lyrics;
@end

static LyricManager *manager = nil;

@implementation LyricManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LyricManager alloc] init];
    });
    return manager;
}

// 根据传过来的歌词进行分隔
- (void)loadLyricWith:(NSString *)lyricStr {
    // 1.分行
    NSMutableArray *lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"] mutableCopy];
    // 最后一行@""
    // 移除最后一行
    [lyricStringArray removeLastObject];
    
    // 现将之前歌曲的歌词移除
    [self.lyrics removeAllObjects];
    
    for (NSString *str in lyricStringArray) {
        // 2.分开时间和歌词 [02:13.640]停留在冬夜的冷风中
        NSArray *timeAndLyric = [str componentsSeparatedByString:@"]"];
        
        // 3.去掉左边的"["
        NSString *time = [timeAndLyric[0] substringFromIndex:1];
        
        // time  02:13.640
        
        // 4.截取时间获取分和秒
        NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
        // 分
        NSInteger minute = [minuteAndSecond[0] integerValue];
        // 秒
        double second = [minuteAndSecond[1] doubleValue];
        
        // 5.存放到model中
        LyricModel *model = [[LyricModel alloc] initWithTime:(minute * 60 + second) andWithLyric:timeAndLyric[1]];
        // 6.添加到数组中
        [self.lyrics addObject:model];
    }
}

- (NSMutableArray *)lyrics {
    if (!_lyrics) {
        _lyrics = [NSMutableArray arrayWithCapacity:5];
    }
    return _lyrics;
}

- (NSArray *)allLyricArray {
    return _lyrics;
}


// 根据播放时间获取到播放到该播放的歌词的索引
- (NSInteger)indexWith:(NSTimeInterval)time {
    NSInteger index = 0;
    for (int i = 0; i < self.lyrics.count; i++) {
        LyricModel *model = self.lyrics[i];
        if (model.time > time) {
            // 注意如果是第0个元素，而且元素时间比要播放的时间大，i-1就会小于0，这样tableView就会crash
            index = (i - 1 > 0) ? i - 1 : 0;
            // 一定要break，要不然就会一直循环下去。
            break;
        }
    }
    return index;
}
@end
