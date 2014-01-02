//
//  RingtoneCreatorViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRangeSlider.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TPAACAudioConverter.h"
#import "DSActivityView.h"

@interface RingtoneCreatorViewController : UIViewController<TPAACAudioConverterDelegate, UIScrollViewDelegate> {
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
    
    NSTimer *timerLimit;
    TPAACAudioConverter *audioConverter;
    
    NSString *lastConvertedCafName;
    
    FloatRange rangeCurrent;

}

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
