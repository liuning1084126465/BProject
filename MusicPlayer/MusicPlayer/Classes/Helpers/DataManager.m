//
//  DataManager.m
//  MusicPlayer
//
//  Created by liuning on 15/11/4.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import "DataManager.h"
#import "MusicModel.h"

static DataManager *dataManager = nil;

@implementation DataManager
+ (DataManager *)sharedManager {
    // gcd提供的一种单例方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[DataManager alloc] init];
        [dataManager requestData];
    });
    return dataManager;
}

- (void)requestData {
    // 开辟子线程，在子线程中访问数据，防止假死
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:kMusicListURL];
        NSArray *dataArray = [NSArray arrayWithContentsOfURL:url];
        for (NSDictionary *dic in dataArray) {
            MusicModel *music = [MusicModel new];
            [music setValuesForKeysWithDictionary:dic];
            [self.musicArray addObject:music];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.updataUI();
        });
    });
    
}

#pragma mark 懒加载
- (NSMutableArray *)musicArray {
    if (_musicArray == nil) {
        _musicArray = [NSMutableArray arrayWithCapacity:20];
    }
    return _musicArray;
}

- (MusicModel *)musicModel:(NSInteger)index {
    return self.musicArray[index];
}

@end
