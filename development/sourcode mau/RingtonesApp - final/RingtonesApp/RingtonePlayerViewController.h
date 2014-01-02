//
//  RingtonePlayerViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RingtonePlayerViewController : UIViewController {
    AVAudioPlayer *player;
    
    IBOutlet UIButton *buttonClose;
    IBOutlet UIButton *buttonPlayPause;
    IBOutlet UISlider *sliderTimeline;
    
    IBOutlet UILabel *labelCurrentTime;
    IBOutlet UILabel *labelRemainingTime;
    
    UIViewController *hostVC;
    
    NSTimer *timerPlaytime;
}

@property(nonatomic, retain) AVAudioPlayer *player;

- (void)updateFrame;
- (IBAction)buttonCloseClicked:(id)sender;
- (IBAction)buttonPlayPauseClicked:(id)sender;
- (IBAction)sliderTimelineValueChanged:(id)sender;

- (void)playRingtone:(NSString *)name;
- (void)playRingtone:(NSString *)name onViewController:(UIViewController *)viewController;

- (void)stopPlayingRingtoneAndRemoveFromSuperView;

@end
