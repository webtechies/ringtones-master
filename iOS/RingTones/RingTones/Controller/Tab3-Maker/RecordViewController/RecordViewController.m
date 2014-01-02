//
//  RecordViewController.m
//  RingTones
//
//  Created by VinhTran on 12/17/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "RecordViewController.h"
#import "MainMakerViewController.h"

@interface RecordViewController ()

@end


#define kLimitTime 300

@implementation RecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        slider.value = 0;
        self.timeDuration = 0;
    }
    return self;
}

- (IBAction) startRecording
{
    if (btnStartRecord.tag==1) {
        self.timeDuration = slider.value;
        [recorder pause];
        btnStartRecord.tag=2;
        [btnStartRecord setImage:[UIImage imageNamed:@"Btn_record.png"] forState:UIControlStateNormal];
        [timer invalidate];
        return;
    }
    if (btnStartRecord.tag==2) {
        [recorder record];
        btnStartRecord.tag = 1;
        slider.value = self.timeDuration;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlide:) userInfo:nil repeats:YES];
        [btnStartRecord setImage:[UIImage imageNamed:@"Btn_stop.png"] forState:UIControlStateNormal];
        return;
    }
    btnStartRecord.tag = 1;
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	[audioSession setActive:YES error:&err];
	err = nil;
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	
	recordSetting = [[NSMutableDictionary alloc] init];
	
	// We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
	[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    
	// We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
	[recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
	
	// We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
	[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	
	recorderFilePath = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, recordFileTemp] ;
	
	NSLog(@"recorderFilePath: %@",recorderFilePath);
	
	NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
	
	err = nil;
	
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
	if(audioData)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
	}
	
	err = nil;
	recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        return;
	}
	
	//prepare to record
	[recorder setDelegate:self];
	[recorder prepareToRecord];
	recorder.meteringEnabled = YES;
	
//	BOOL audioHWAvailable = NO;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//        audioHWAvailable = audioSession.inputIsAvailable;
//    }
//    
//	if (! audioHWAvailable) {
//        UIAlertView *cantRecordAlert =
//        [[UIAlertView alloc] initWithTitle: @"Warning"
//								   message: @"Audio input hardware not available"
//								  delegate: nil
//						 cancelButtonTitle:@"OK"
//						 otherButtonTitles:nil];
//        [cantRecordAlert show];
//        return;
//	}
	
	// start recording
	[recorder recordForDuration:(NSTimeInterval) kLimitTime];
	
//	lblStatusMsg.text = @"Recording...";
	progressView.progress = 0.0;
    slider.value = 0;
    [btnStartRecord setImage:[UIImage imageNamed:@"Btn_stop.png"] forState:UIControlStateNormal];
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlide:) userInfo:nil repeats:YES];
}

- (IBAction) stopRecording
{
    [recorder stop];
	
	[timer invalidate];
//	lblStatusMsg.text = @"Stopped";
	progressView.progress = 1.0;
    slider.value = 1;
    
	
	//NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
    //	NSError *err = nil;
    //	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    //	if(!audioData)
    //        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    //	[editedObject setValue:[NSData dataWithContentsOfURL:url] forKey:@"editedFieldKey"];
    //
    //	//[recorder deleteRecording];
    //
    //
    //	NSFileManager *fm = [NSFileManager defaultManager];
    //
    //	err = nil;
    //	[fm removeItemAtPath:[url path] error:&err];
    //	if(err)
    //        NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
	
	
}






- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	NSLog (@"audioRecorderDidFinishRecording:successfully:");
	[timer invalidate];
//	lblStatusMsg.text = @"Stopped";
	progressView.progress = 1.0;
    slider.value = 1;
}




-(void) customProcessView
{
    //--custom silider
    
    
//    UIImage *sliderMinimum = [[UIImage imageNamed:@"Selection_range.png"] stretchableImageWithLeftCapWidth:2  topCapHeight:0];
//    [slider setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
    //[slider setTintColor:[UIColor colorWithRed:135 green:255 blue:185 alpha:0.7]];
   // UIImage *sliderMaximum = [[UIImage imageNamed:@"img_Slider_track_non_value_new.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    //[slider setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 60.0f);
    slider.transform = transform;
    [slider setThumbImage:[UIImage imageNamed:@"Playing_line.png"] forState:UIControlStateNormal];
    
//    //[progressView setTrackImage:[UIImage imageNamed:@"Btn_record@2x"]];
//    [progressView setTrackTintColor:[UIColor blueColor]];
//    [progressView setProgressTintColor:[UIColor yellowColor]];
//  //  progressView.frame = CGRectMake(0, 0, 295, 158);
//    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 158.0f);
//    progressView.transform = transform;
    

    
}



////////////////////////////////////////////////////////////
#pragma mark  - Slider


- (IBAction)sliderMoved:(UISlider *)aSlider {
//    if (audioPlayer.duration)
//	{
//        [slider setEnabled:YES];
//        self.audioPlayer.currentTime = self.audioPlayer.duration* aSlider.value;
//	}
    
    [slider setEnabled:NO];
   // self.audioPlayer.currentTime = self.audioPlayer.duration* aSlider.value;
    
}


- (void)updateSlide:(NSTimer *)updatedTimer
{
//    double currentTime = self.audioPlayer.currentTime;
//    if (currentTime > 0)
//    {
//        [slider setEnabled:YES];
//        [slider setValue:currentTime/self.audioPlayer.duration];
//    }
//    else
//    {
//        
//    }
    static int i=0;
    i++;
    if (i%10==0) {
        NSLog(@"handle: %d", i);
        lblDuration.text = [self displayTimeWithSecond:i/10];// [NSString stringWithFormat:@"%d",i/10];
    }
    
    
    slider.value += 0.0025;
    [slider setEnabled:NO];

	if(slider.value >= 1.0)
	{
        slider.value = 0;
        lblTimeStart.text = [self displayTimeWithSecond:kDefaultDurationPerScreen * (int)(i/kDefaultDurationPerScreen)];
        lblTimeEnd.text = [self displayTimeWithSecond:(i/kDefaultDurationPerScreen) *kDefaultDurationPerScreen + kDefaultDurationPerScreen];
//        [btnStartRecord setImage:[UIImage imageNamed:@"Btn_record.png"] forState:UIControlStateNormal];
//		[timer invalidate];
	}
    
}


- (NSString *)displayTimeWithSecond:(NSInteger)seconds
{
    NSString *timeStr = @"";
    NSInteger remindMinute = seconds / 60;
    NSInteger remindHours = remindMinute / 60;
    
    NSInteger remindMinutes = seconds - (remindHours * 3600);
    NSInteger remindMinuteNew = remindMinutes / 60;
    
    NSInteger remindSecond = seconds - (remindMinuteNew * 60) - (remindHours * 3600);

    timeStr = [NSString stringWithFormat:@"%02d:%02d",remindMinuteNew,remindSecond];
    return timeStr;
}



-(void) deleteRecordFileTemp{
    NSString *filePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:recordFileTemp];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    
}


- (IBAction) btnCountinuePress{
    MainMakerViewController *creator = [[MainMakerViewController alloc]initWithNibName:@"MainMakerViewController" bundle:nil];
    creator.songid = @"-1";
    [self.navigationController pushViewController:creator animated:YES];

}


- (void)viewDidLoad
{
    [self customProcessView];
    [super viewDidLoad];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
