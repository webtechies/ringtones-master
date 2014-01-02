//
//  MainMakerViewController.h
//  RingTones
//
//  Created by VinhTran on 12/17/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRangeSlider.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TPAACAudioConverter.h"
#import "DSActivityView.h"
#import "SongModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface MainMakerViewController : UIViewController<TPAACAudioConverterDelegate, UIScrollViewDelegate> {
    IBOutlet UIView *sliderPlaceHolder;
    IBOutlet UIButton *buttonPlay;
    IBOutlet UIButton *buttonConvert;
    IBOutlet UILabel *labelStart;
    IBOutlet UILabel *labelEnd;
    IBOutlet UILabel *labelDuration;
    IBOutlet UIScrollView *scrollRange;
    IBOutlet UIImageView *imgviewPlayingIndi;
    IBOutlet UIImageView *imgviewSelectionLeft;
    IBOutlet UIImageView *imgviewSelectionRight;
    IBOutlet UIView *viewSelection;
    
    CGFloat startRange;
    CGFloat endRange;
    
    
    ASRangeSlider *slider;
    
    MPMediaItem *selectedItem;
    
    MPMusicPlayerController *player;
    AVAudioPlayer * sound;
    
    NSTimer *timerLimit;
    TPAACAudioConverter *audioConverter;
    
    NSString *lastConvertedCafName;
    
    FloatRange rangeCurrent;
    
    
    SongModel *songModel;
    
}

@property (nonatomic, retain) NSString *songid;
@property (nonatomic, retain) SongModel *songModel;
@property (retain, nonatomic) NSString *path;
@property (nonatomic, retain) ASRangeSlider *slider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedItem:(MPMediaItem *)item;

- (IBAction)buttonPlayClicked:(id)sender;
- (IBAction)buttonConvertClicked:(id)sender;

- (void)startTimer;
- (void)stopTimer;
- (void)timerTick;
- (void)startConvertCafToM4r;

- (NSString *) urlPathForRecord;
- (void) startRecordingConvert;

@end
