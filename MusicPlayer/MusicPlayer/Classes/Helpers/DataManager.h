//
//  DataManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

typedef void(^UpdataUI)();

@interface DataManager : NSObject
/**
 *  单例声明
 */
+ (DataManager *)sharedManager;
@property (nonatomic, strong) NSMutableArray *musicArray;
// 定义block数字那个
@property (nonatomic, copy) UpdataUI updataUI;
// 返回一个model
- (MusicModel *)musicModel:(NSInteger)index;
@end
