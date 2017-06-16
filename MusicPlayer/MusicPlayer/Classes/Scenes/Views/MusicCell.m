//
//  MusicCell.m
//  MusicPlayer
//
//  Created by liuning on 15/11/4.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import "MusicCell.h"
#import "UIImageView+WebCache.h"

@interface MusicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@end

@implementation MusicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMusic:(MusicModel *)music {
    _music = music; // 根据需求，是否传值model，model可以赋值，全值，如果没有这一句话，在cell上无法取到model
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:nil];
    self.musicName.text = music.name;
    self.singer.text = music.singer;
}

@end
