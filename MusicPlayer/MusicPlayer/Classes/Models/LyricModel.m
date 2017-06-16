//
//  LyricModel.m
//  MusicPlayer
//
//  Created by liuning on 15/11/10.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel
- (instancetype)initWithTime:(NSTimeInterval)time andWithLyric:(NSString *)lyricContext {
    if (self = [super init]) {
        _time = time;
        _lyricContext = lyricContext;
    }
    return self;
}
@end
