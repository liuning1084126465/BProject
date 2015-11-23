//
//  PlayingViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import "PlayingViewController.h"
#import "MusicModel.h"
#import "DataManager.h"
#import "PlayerManger.h"
#import "LyricManager.h"
#import "LyricModel.h"

@interface PlayingViewController () <PlayerMangerDelegate, UITableViewDataSource, UITableViewDelegate>

// 记录当前正在播放的音乐
@property (nonatomic, strong) MusicModel *musicModel;
// 判断是否和上一次点击的cell下标相等，相等的话，同一首歌，继续播放
@property (nonatomic, assign) NSInteger currentIndex;

#pragma mark 控件
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UIImageView *img4Pic;
@property (weak, nonatomic) IBOutlet UILabel *lab4PlayedTime;
@property (weak, nonatomic) IBOutlet UILabel *lab4LastTime;
@property (weak, nonatomic) IBOutlet UISlider *slider4Time;
@property (weak, nonatomic) IBOutlet UISlider *slider4Volume;
@property (weak, nonatomic) IBOutlet UIButton *btn4PlayOrPause;
@property (weak, nonatomic) IBOutlet UITableView *tableView4Lyric;

#pragma mark --控件事件
- (IBAction)action4Prev:(id)sender;
- (IBAction)playOrPauseAction:(UIButton *)sender;
- (IBAction)next:(id)sender;
- (IBAction)changeTimeAction:(UISlider *)sender;
- (IBAction)changeVolumAction:(UISlider *)sender;

@end

static PlayingViewController *playingVC = nil;
static NSString *identifier = @"cell";

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 由于初始值为0，所以更改和cell下表不一样的数
    _currentIndex = -1;
    
    // 切圆角
    self.img4Pic.layer.masksToBounds = YES;
    self.img4Pic.layer.cornerRadius = self.img4Pic.frame.size.width / 2;
    
    // 设置自己为播放器的代理，帮播放器干一些事情
    [PlayerManger sharedManger].delegate = self;
    
    // 注册cell
    [self.tableView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    // 设置初始值音量进度条
    self.slider4Volume.value = [[PlayerManger sharedManger] volume];
}

#pragma PlayerMangerDelegate中的代理
// 播放器播放下一首
- (void)playerDidPlayEnd {
    // 直接触发下一首按钮的事件
    [self next:nil];
}

#pragma mark --控件事件
// 上一首
- (IBAction)action4Prev:(id)sender {
    _currentIndex--;
    if (_currentIndex == -1) {
        _currentIndex = [DataManager sharedManager].musicArray.count - 1;
    }
    [self startPlay];
}

// 播放器每0.1秒回让代理(也就是这个页面)执行一下这个事件
- (void)playerPlayingWithTime:(NSTimeInterval)time {
    self.slider4Time.value = time;
    
    self.lab4PlayedTime.text = [self stringWithTime:time];
    
    // 剩余时间
    NSTimeInterval time2 = [self.musicModel.duration integerValue] / 1000 - time;
    self.lab4LastTime.text = [self stringWithTime:time2];
    
    // 每0.1秒旋转1度
    self.img4Pic.transform = CGAffineTransformRotate(self.img4Pic.transform, M_PI / 180);
    
    // 根据当前播放时间获取到应该播放的那句歌词
    NSInteger indexPath = [[LyricManager sharedManager] indexWith:time];
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath inSection:0];
    // 让tableView选中一行
    [self.tableView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

// 根据时间获取到字符串
- (NSString *)stringWithTime:(NSTimeInterval)time {
    NSInteger minutes = time / 60;
    NSInteger seconds = (int)time % 60;
    return [NSString stringWithFormat:@"%ld:%ld", minutes, seconds];
}

// 暂停或者播放事件
- (IBAction)playOrPauseAction:(UIButton *)sender {
    NSLog(@"%d", [PlayerManger sharedManger].isPlaying);
    // 判断是否是播放状态
    if ([PlayerManger sharedManger].isPlaying) {
        [[PlayerManger sharedManger] pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    } else {
        [[PlayerManger sharedManger] play];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

// 下一首
- (IBAction)next:(id)sender {
    // 进行下一首之前把原来的停止
//    [[PlayerManger sharedManger] pause];
    
    _currentIndex++;
//    NSLog(@"%ld", _currentIndex);
    if (_currentIndex == [DataManager sharedManager].musicArray.count) {
        // 如果是最后一首就播放第一首
        _currentIndex = 0;
    }
    [self startPlay];
}

// 改变播放的进度
- (IBAction)changeTimeAction:(UISlider *)sender {
    // 调用接口
    [[PlayerManger sharedManger] seekToTime:sender.value];
//    NSLog(@"%f", sender.value);
}

// 改变音量大小
- (IBAction)changeVolumAction:(UISlider *)sender {
    [[PlayerManger sharedManger] changeToVolume:sender.value];
}

#pragma mark 懒加载
- (MusicModel *)musicModel {
    // 由于是单例模式不能进行判断是否为空
//    if (_musicModel == nil) {
    _musicModel = [[DataManager sharedManager] musicModel:self.currentIndex];
//    }
    return _musicModel;
}

// 因为是单例创建，所以要把代码写在viewWillAppear方法中
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 判断点击的是否是之前点击的cell
    if (_currentIndex == _index) {
        return;
    }
    _currentIndex = _index;
    [self startPlay];
}

// 页面出现的时候下一首上一首播从新播放时间
- (void)startPlay {
//    self.musicModel = [[DataManager sharedManager] musicModel:self.currentIndex];
    [[PlayerManger sharedManger] playWithUrlString:self.musicModel.mp3Url];
    // 重新更新UI
    [self buildUI];
}

// 重新更新UI
- (void)buildUI {
    // 设置歌曲名
    self.musicName.text = self.musicModel.name;
    // 设置歌手名
    self.singerName.text = self.musicModel.singer;
    // 设置图片
    [self.img4Pic sd_setImageWithURL:[NSURL URLWithString:self.musicModel.picUrl]];
    
    // 更改暂停和播放按钮的状态
    [self.btn4PlayOrPause setTitle:@"暂停" forState:UIControlStateNormal];
    
    // 改变进度条的最大值
    self.slider4Time.maximumValue = [self.musicModel.duration integerValue] / 1000;
//    NSLog(@"%f", self.slider4Time.maximumValue);
    
    // 更改旋转的角度,图片归位
    self.img4Pic.transform = CGAffineTransformMakeRotation(0);
    
    // 调用解析歌词的方法,防止没有歌词
    if (self.musicModel.lyric.length != 0) {
        [[LyricManager sharedManager] loadLyricWith:self.musicModel.lyric];
    }
    
    // 从新刷新tableView
    [self.tableView4Lyric reloadData];
}

// 单例创建视图控制器
+ (PlayingViewController *)sharedPlayingVC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 拿到Main.storboard中的容器视图控制器
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        // 在Main.storyboard中找到想要用的控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
    });
    return playingVC;
}

- (IBAction)action4Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource中代理
// 返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 每组中又多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LyricManager sharedManager].allLyricArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    cell.textLabel.text = @"歌词";
    if (self.musicModel.lyric.length != 0) {
        LyricModel *lyric = [LyricManager sharedManager].allLyricArray[indexPath.row];
        cell.textLabel.text = lyric.lyricContext;
    } else {
        cell.textLabel.text = @"无歌词";
    }
    
    // 设置居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
@end
