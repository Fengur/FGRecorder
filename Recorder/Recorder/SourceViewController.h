//
//  SourceViewController.h
//  Recorder
//
//  Created by Fengur on 2016/10/18.
//  Copyright © 2016年 code.sogou.fengur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *sourceTableView;
@property (nonatomic, strong) NSMutableArray *sorceFileArray;
@end
