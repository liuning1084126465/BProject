//
//  PlayingViewController.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface PlayingViewController : UIViewController

//@property (nonatomic, strong) MusicModel *music;
@property (nonatomic, assign) NSInteger index;
+ (PlayingViewController *)sharedPlayingVC;

@end
