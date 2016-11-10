//
//  PlayViewController.h
//  Recorder
//
//  Created by Fengur on 2016/10/18.
//  Copyright © 2016年 code.sogou.fengur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio/EZAudio.h"

@interface PlayViewController : UIViewController<EZAudioPlayerDelegate>

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) EZAudioPlot *playAudioPlot;
@property (nonatomic, strong) EZAudioPlayer *player;
@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *startPlayBtn;
@property (nonatomic, strong) UIButton *stopPlayBtn;
@property (nonatomic, strong) UIButton *operateBtn;

@end
