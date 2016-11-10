//
//  SourceViewController.m
//  Recorder
//
//  Created by Fengur on 2016/10/18.
//  Copyright © 2016年 code.sogou.fengur. All rights reserved.
//

#import "SourceViewController.h"
#import "PlayViewController.h"

@interface SourceViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [FGFastInit navBarTitle:@"录音列表"];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectZero];
    self.sourceTableView.tableFooterView = footerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [self scanFilesInDocument];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sorceFileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sgTabelViewCellIdentifier = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sgTabelViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:sgTabelViewCellIdentifier];
    }
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.text = _sorceFileArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = DailyFont(14.f);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.sourceTableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayViewController *playerVC = [PlayViewController new];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
        NSString *targetPath = [NSString stringWithFormat:@"%@/RecorderSource/%@",[self applicationDocumentsDirectory],_sorceFileArray[indexPath.row]];
    playerVC.filePath = targetPath;
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (NSMutableArray *)sorceFileArray{
    if(!_sorceFileArray){
        _sorceFileArray = [[NSMutableArray alloc]init];
    }
    return _sorceFileArray;
}

- (void)scanFilesInDocument{
    NSString *targetPath = [NSString stringWithFormat:@"%@/RecorderSource",[self applicationDocumentsDirectory]];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager directoryContentsAtPath:targetPath];
    _sorceFileArray = [array mutableCopy];
    [self.sourceTableView reloadData];
    
}

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
