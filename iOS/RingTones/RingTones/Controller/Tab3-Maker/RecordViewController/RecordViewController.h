//
//  RecordViewController.h
//  RingTones
//
//  Created by VinhTran on 12/17/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface RecordViewController : UIViewController<AVAudioRecorderDelegate>{
    
    NSMutableDictionary *recordSetting;
	NSMutableDictionary *editedObject;
    NSString *recorderFilePath;
	AVAudioRecorder *recorder;
	
	SystemSoundID soundID;
	NSTimer *timer;
    
    __weak IBOutlet UIButton *btnStartRecord;
    __weak IBOutlet UIProgressView *progressView;
    __weak IBOutlet UIButton *btnContinue;
    
    __weak IBOutlet UISlider *slider;
    __weak IBOutlet UILabel *lblTimeStart;
    __weak IBOutlet UILabel *lblDuration;
    __weak IBOutlet UILabel *lblTimeEnd;
    
}

@property (nonatomic, assign) float timeDuration;

@end
