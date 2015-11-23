//
//  MusicModel.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    NSLog(@"error : %@", key);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@", _name];
}
@end
