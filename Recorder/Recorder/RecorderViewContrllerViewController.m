//
//  RecorderViewContrllerViewController.m
//  Recorder
//
//  Created by Fengur on 16/9/23.
//  Copyright © 2016年 code.sogou.fengur. All rights reserved.
//

#import "JCAlertView.h"
#import "RecorderViewContrllerViewController.h"
#import "SettingViewController.h"
#import "SourceViewController.h"

@interface RecorderViewContrllerViewController ()

@end

@implementation RecorderViewContrllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setAIOpen];
    self.navigationItem.titleView = [FGFastInit navBarTitle:@"录音机"];
    [self setupControls];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"set seesionCategory error:%@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"set seesionActive error:%@", error.localizedDescription);
    }

    self.recordingView.color = [UIColor blackColor];
    self.recordingView.plotType = EZPlotTypeRolling;
    self.recordingView.shouldFill = YES;
    self.recordingView.gain = 2.f;
    self.recordingView.shouldMirror = YES;
    self.micophone = [EZMicrophone microphoneWithDelegate:self];

    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error) {
        NSLog(@"override output to speaker:%@", error.localizedDescription);
    }

    [self.micophone startFetchingAudio];
}

- (void)setAIOpen {
    UIView *hideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:hideView];
    hideView.backgroundColor = [UIColor blackColor];

    [UIView animateWithDuration:0.618f
        animations:^{
            hideView.alpha = 0;
        }
        completion:^(BOOL finished) {
            [hideView removeFromSuperview];
        }];
}

- (void)setupControls {
    _startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [FGSizeTool heightWithSize6:80],
                                                              [FGSizeTool heightWithSize6:50])];
    _startButton.layer.cornerRadius = 10;
    _startButton.layer.borderWidth = 1;
    _startButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _startButton.backgroundColor = [UIColor clearColor];
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startButton.titleLabel.font = DailyFont(14.f);
    [_startButton addTarget:self
                     action:@selector(startRecordAction:)
           forControlEvents:UIControlEventTouchUpInside];
    _startButton.centerX = ScreenWidth / 2;
    _startButton.centerY = (ScreenHeight - 400 - NavHeight) / 2;
    [_controlView addSubview:_startButton];

    _stopButton = [[UIButton alloc] init];
    _stopButton.bounds = _startButton.bounds;
    _stopButton.x = PADDING_CELL;
    _stopButton.centerY = _startButton.centerY * 3;
    _stopButton.backgroundColor = [UIColor clearColor];
    [_controlView addSubview:_stopButton];
    _stopButton.layer.cornerRadius = 10;
    _stopButton.layer.borderWidth = 1;
    _stopButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _stopButton.titleLabel.font = _startButton.titleLabel.font;
    [_stopButton setTitle:@"暂停" forState:UIControlStateNormal];
    [_stopButton setTitle:@"继续" forState:UIControlStateSelected];
    _stopButton.selected = NO;
    [_stopButton addTarget:self
                    action:@selector(pasueAndContinueAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    _saveButton = [[UIButton alloc] init];
    _saveButton.bounds = _startButton.bounds;
    _saveButton.x = ScreenWidth - _startButton.width - PADDING_CELL;
    _saveButton.centerY = _startButton.centerY * 3;
    _saveButton.backgroundColor = [UIColor clearColor];
    [_controlView addSubview:_saveButton];
    _saveButton.layer.cornerRadius = 10;
    _saveButton.layer.borderWidth = 1;
    _saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _saveButton.titleLabel.font = _startButton.titleLabel.font;
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton addTarget:self
                    action:@selector(saveAction)
          forControlEvents:UIControlEventTouchUpInside];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    _currentTimeLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, ScreenWidth, [FGSizeTool heightWithSize6:40])];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.font = SingleFont(22.f);
    [_controlView addSubview:_currentTimeLabel];

    
    _stopButton.clipsToBounds = YES;
    _startButton.clipsToBounds = YES;
    _saveButton.clipsToBounds = YES;
}

- (void)microphone:(EZMicrophone *)microphone
        hasAudioReceived:(float **)buffer
          withBufferSize:(UInt32)bufferSize
    withNumberOfChannels:(UInt32)numberOfChannels {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.recordingView updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}
- (IBAction)menuAction:(id)sender {
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self presentViewController:settingVC animated:YES completion:nil];
}

- (IBAction)sourceAction:(id)sender {
    SourceViewController *sourceVC = [[SourceViewController alloc] init];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:nil
                                                                     action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:sourceVC animated:YES];
}

//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone
           hasBufferList:(AudioBufferList *)bufferList
          withBufferSize:(UInt32)bufferSize
    withNumberOfChannels:(UInt32)numberOfChannels {
    if (self.isRecording) {
        [self.recorder appendDataFromBufferList:bufferList withBufferSize:bufferSize];
    }
}

#pragma mark - EZRecorderDelegate

- (void)recorderDidClose:(EZRecorder *)recorder {
    recorder.delegate = nil;
}

- (void)recorderUpdatedCurrentTime:(EZRecorder *)recorder {
    __weak typeof(self) weakSelf = self;
    NSString *formattedCurrentTime = [recorder formattedCurrentTime];
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.currentTimeLabel.text = formattedCurrentTime;
    });
}

- (void)startRecordAction:(UIButton *)sender {
    __block typeof(self) bself = self;
    if (self.isRecording || self.isPaused) {
        [JCAlertView showTwoButtonsWithTitle:@"提示"
                                     Message:@"是否舍弃当前录音重新开始?"
                                  ButtonType:1
                                 ButtonTitle:@"取消"
                                       Click:nil
                                  ButtonType:2
                                 ButtonTitle:@"确定"
                                       Click:^{
                                           [bself startRecorder];
                                       }];

    } else {
        [self startRecorder];
    }
}

- (void)startRecorder {
    
    [self.recordingView clear];

    [self.micophone stopFetchingAudio];
    [self.micophone startFetchingAudio];
    [self.recorder closeAudioFile];
    [self clearnUnSavedFile];
    self.recorder = [EZRecorder recorderWithURL:[self testFilePathURL]
                                   clientFormat:[self.micophone audioStreamBasicDescription]
                                       fileType:EZRecorderFileTypeWAV
                                       delegate:self];
    self.isRecording = YES;
    [UIView animateWithDuration:0.5f
        animations:^{
            _saveButton.centerY = _startButton.centerY;
            _stopButton.centerY = _startButton.centerY;
        }
        completion:^(BOOL finished){

        }];
}

- (void)pasueAndContinueAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.micophone stopFetchingAudio];
        self.isRecording = NO;
        self.isPaused = YES;
    } else {
        [self.micophone startFetchingAudio];
        self.isRecording = YES;
        self.isPaused = NO;
    }
}

- (void)saveAction {
    self.isRecording = NO;
    self.isPaused = NO;
    self.currentTimeLabel.text = @"";

    [UIView animateWithDuration:0.5f
        animations:^{
            _saveButton.centerY = _startButton.centerY * 3;
            _stopButton.centerY = _startButton.centerY * 3;
        }
        completion:^(BOOL finished) {
            SourceViewController *sourceVC = [[SourceViewController alloc] init];
            UIBarButtonItem *barButtonItem =
                [[UIBarButtonItem alloc] initWithTitle:@""
                                                 style:UIBarButtonItemStyleDone
                                                target:nil
                                                action:nil];
            self.navigationItem.backBarButtonItem = barButtonItem;
            self.currentTimeLabel.text = @"";
            [self.navigationController pushViewController:sourceVC animated:YES];
        }];
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSURL *)testFilePathURL {
    [self.recorder closeAudioFile];
    _currentFilePath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/RecorderSource/%@.wav",
                                               [self applicationDocumentsDirectory],
                                               [self fg_stringDate]]];
    return _currentFilePath;
}

- (NSURL *)currentFilePath{
    if(!_currentFilePath){
        _currentFilePath = [[NSURL alloc]init];
    }
    return _currentFilePath;
}

- (void)clearnUnSavedFile{
    BOOL isCleanSuccess = [[NSFileManager defaultManager] removeItemAtURL:_currentFilePath error:nil];
    if(isCleanSuccess){
        FGLog(@"当前录音路径已清理");
    }
    
}

- (NSString *)fg_stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd_HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
