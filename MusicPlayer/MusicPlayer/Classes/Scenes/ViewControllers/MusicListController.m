//
//  MusicListController.m
//  MusicPlayer
//
//  Created by liuning on 15/11/4.
//  Copyright © 2015年 liuning.com. All rights reserved.
//

#import "MusicListController.h"
#import "MusicCell.h"
#import "DataManager.h"
#import "PlayerManger.h"
#import "PlayingViewController.h"

@interface MusicListController ()

@end

static NSString *cellIdentifier = @"musicCell";
static NSString *customIdentifier = @"customCell";

@implementation MusicListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:customIdentifier];
    
    [DataManager sharedManager].updataUI = ^(){
        [self.tableView reloadData];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataManager sharedManager].musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:customIdentifier forIndexPath:indexPath];
    
    cell.music = [[DataManager sharedManager] musicModel:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", cell.music);
    
//    [[PlayerManger sharedManger] playWithUrlString:cell.music.mp3Url];
    
    PlayingViewController *playingVC = [PlayingViewController sharedPlayingVC];
    // 传值，传过去当前点击的cell为第几个
    playingVC.index = indexPath.row;
    // 模态的另一种方法
    [self showDetailViewController:playingVC sender:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
