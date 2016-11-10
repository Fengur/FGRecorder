//
//  PlayViewController.m
//  Recorder
//
//  Created by Fengur on 2016/10/18.
//  Copyright © 2016年 code.sogou.fengur. All rights reserved.
//

#import "PlayViewController.h"
@interface PlayViewController () {
    
}
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [FGFastInit navBarTitle:@"录音播放"];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setupControls];
    [self setupNotifications];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEndOfFile:)
                                                 name:EZAudioPlayerDidReachEndOfFileNotification
                                               object:self.player];
}

- (void)playerDidChangePlayState:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        EZAudioPlayer *player = [notification object];
        BOOL isPlaying = [player isPlaying];
        
    });
}

- (void)playerDidReachEndOfFile:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.playAudioPlot clear];
        [weakSelf.startPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.currentTimeLabel.x = -100;
            weakSelf.totalTimeLabel.x = ScreenWidth;
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)setupControls {
    self.player = [EZAudioPlayer audioPlayerWithDelegate:self];

    self.playAudioPlot =
        [[EZAudioPlot alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 400)];
    [self.view addSubview:self.playAudioPlot];
    self.playAudioPlot.color = [UIColor whiteColor];
    self.playAudioPlot.backgroundColor = RGBACOLOR(0, 0, 0, 1);
    self.playAudioPlot.plotType = EZPlotTypeRolling;
    self.playAudioPlot.shouldFill = YES;
    self.playAudioPlot.shouldMirror = YES;
    self.playAudioPlot.gain = 2.f;

    self.controlView = [[UIView alloc]
        initWithFrame:CGRectMake(0, self.playAudioPlot.height + NavHeight, ScreenWidth,
                                 ScreenHeight - NavHeight - self.playAudioPlot.height)];
    self.controlView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.controlView];

    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 40, ScreenWidth - 40, 20)];
    _progressView.layer.cornerRadius = 0;
    _progressView.layer.masksToBounds = YES;
    _progressView.layer.borderWidth = 0.3;
    _progressView.layer.borderColor = [UIColor whiteColor].CGColor;
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    _progressView.alpha = 1.0f;
    _progressView.progressTintColor = [UIColor blackColor];
    _progressView.trackTintColor = [UIColor whiteColor];
    _progressView.progress = 0;
    [_progressView setProgressViewStyle:UIProgressViewStyleBar];
    [_controlView addSubview:_progressView];
    
    _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(-100, 15, 80, 20)];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.textAlignment = NSTextAlignmentLeft;
    _currentTimeLabel.font = SingleFont(14.f);
    _currentTimeLabel.text = @"00:00";
    [_controlView addSubview:_currentTimeLabel];

    _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth, 15, 80, 20)];
    _totalTimeLabel.textColor = [UIColor whiteColor];
    _totalTimeLabel.textAlignment = NSTextAlignmentRight;
    _totalTimeLabel.font = SingleFont(14.f);
    _totalTimeLabel.text = @"00:00";
    [_controlView addSubview:_totalTimeLabel];

    _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 45, ScreenWidth - 40, 20)];
    _slider.minimumTrackTintColor = [UIColor clearColor];
    _slider.maximumTrackTintColor = [UIColor clearColor];
    _slider.transform = CGAffineTransformMakeScale(1, 1);
    [_slider setThumbImage:ImageOfName(@"tuodong") forState:UIControlStateNormal];
    [_slider addTarget:self
                  action:@selector(sliderDidEnd:)
        forControlEvents:UIControlEventValueChanged];
    [_controlView addSubview:_slider];
    
    _startPlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [FGSizeTool heightWithSize6:70],
                                                              [FGSizeTool heightWithSize6:70])];
    _startPlayBtn.layer.cornerRadius = [FGSizeTool heightWithSize6:35];
    _startPlayBtn.layer.borderWidth = 1;
    _startPlayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _startPlayBtn.backgroundColor = [UIColor clearColor];
    [_startPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
    [_startPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startPlayBtn.titleLabel.font = DailyFont(14.f);
    [_startPlayBtn addTarget:self
                     action:@selector(startPlayAction:)
           forControlEvents:UIControlEventTouchUpInside];
    _startPlayBtn.centerX = ScreenWidth / 2;
    _startPlayBtn.centerY = (ScreenHeight - 400 - NavHeight + 40) / 2;
    [_controlView addSubview:_startPlayBtn];
    
    
}

- (void)startPlayAction:(UIButton *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        _currentTimeLabel.x = 20;
        _totalTimeLabel.x = ScreenWidth -100;
    } completion:^(BOOL finished) {
        
    }];
    
    if(self.player.isPlaying){
        [self.player pause];
        [_startPlayBtn setTitle:@"继续" forState:UIControlStateNormal];
    }else{
        if(self.player.frameIndex>0){
            [self.player seekToFrame:self.player.frameIndex];
            [self.player play];
        }else{
            EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:[NSURL fileURLWithPath:_filePath]];
            [self.player playAudioFile:audioFile];
        }
        [_startPlayBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }

}

- (void)sliderDidEnd:(UISlider *)sender {
    [self.player seekToFrame:self.player.totalFrames * sender.value];
}

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
             playedAudio:(float **)buffer
          withBufferSize:(UInt32)bufferSize
    withNumberOfChannels:(UInt32)numberOfChannels
             inAudioFile:(EZAudioFile *)audioFile {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.playAudioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.currentTimeLabel.text = audioPlayer.formattedCurrentTime;
        weakSelf.totalTimeLabel.text = audioPlayer.formattedDuration;
        NSString *frameIndex = [NSString stringWithFormat:@"%lld", audioPlayer.frameIndex];
        NSString *totalIndex = [NSString stringWithFormat:@"%lld", audioPlayer.totalFrames];
        float frameCurrent = [frameIndex floatValue];
        float totalFrame = [totalIndex floatValue];

        [weakSelf.progressView setProgress:frameCurrent / totalFrame animated:YES];
        weakSelf.slider.value = weakSelf.progressView.progress;
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
