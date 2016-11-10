//
//  RecorderViewContrllerViewController.h
//  Recorder
//
//  Created by Fengur on 16/9/23.
//  Copyright © 2016年 code.sogou.fengur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio/EZAudio.h"

@interface RecorderViewContrllerViewController : UIViewController<EZRecorderDelegate,EZMicrophoneDelegate>

@property (weak, nonatomic) IBOutlet EZAudioPlotGL *recordingView;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, strong) EZMicrophone *micophone;
@property (nonatomic, strong) EZRecorder *recorder;
@property (nonatomic, strong) UILabel *currentTimeLabel;;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) NSURL *currentFilePath;

@end
