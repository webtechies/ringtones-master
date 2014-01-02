//
//  RingtoneCreatorViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RingtoneCreatorViewController.h"
#import "CommonUtils.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "RingtoneHelpers.h"
#import "AppDelegate.h"




#define checkResult(result,operation) (_checkResult((result),(operation),__FILE__,__LINE__))
static inline BOOL _checkResult(OSStatus result, const char *operation, const char* file, int line) {
    if ( result != noErr ) {
        NSLog(@"%s:%d: %s result %d %08X %4.4s\n", file, line, operation, (int)result, (int)result, (char*)&result); 
        return NO;
    }
    return YES;
}


@implementation RingtoneCreatorViewController


// Callback to be notified of audio session interruptions (which have an impact on the conversion process)
static void interruptionListener(void *inClientData, UInt32 inInterruption)
{
//    id object = (id) inClientData;
//
////    if ([object class] != [RingtoneCreatorViewController class]) {
////        return;
////    }
//    
//	RingtoneCreatorViewController *THIS = (RingtoneCreatorViewController *)inClientData;
//	
//	if (inInterruption == kAudioSessionEndInterruption) {
//		// make sure we are again the active session
//		checkResult(AudioSessionSetActive(true), "resume audio session");
//        if ( THIS->audioConverter ) [THIS->audioConverter resume];
//	}
//	
//	if (inInterruption == kAudioSessionBeginInterruption) {
//        if ( THIS->audioConverter ) [THIS->audioConverter interrupt];
//    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedItem:(MPMediaItem *)item
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        F_RELEASE(selectedItem);
        selectedItem = [item retain];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) updateSliderLabels
{
//	FloatRange r = slider.value;
//    slider.leftmostThumb.textLabel.text = [CommonUtils convertToDateTimeFrom:r.min]; //[NSString stringWithFormat:@"%.2f", r.min];
//	slider.rightmostThumb.textLabel.text = [CommonUtils convertToDateTimeFrom:r.max]; //[NSString stringWithFormat:@"%.2f", r.max];
//    
//    
//    [player setCurrentPlaybackTime:r.min];
    
}

- (void)updateTimeLabels;
{
    FloatRange r = slider.value;
    CGFloat duration =  (int)(r.max - r.min);
//    NSLog(@"update duration: %f", duration);
    
    labelDuration.text = [CommonUtils convertToDateTimeFrom:duration];
    
    
    labelStart.text = [CommonUtils convertToDateTimeFrom:startRange];
    labelEnd.text = [CommonUtils convertToDateTimeFrom:endRange];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //update start/end time

    //calculate start/end range
    CGPoint newOffset = scrollView.contentOffset;
        
    startRange = newOffset.x * durationPerScroll / scrollRange.frame.size.width;
    endRange =  (newOffset.x + scrollRange.frame.size.width) * durationPerScroll / scrollRange.frame.size.width;
    
//    NSLog(@"newOffset x: %f, y: %f\nstart: %f, end: %f", newOffset.x, newOffset.y, startRange, endRange);
    
    [self updateTimeLabels];
}


-(IBAction) sliderValueChanged : (id) sender
{ 
//    FloatRange r = slider.value;
    
//    //detect min/max change
//    if (r.max != rangeCurrent.max) {
//        // change max
//        if (r.max - r.min <= kDefaultRingtoneCutMinDuration) {
//            r.min = r.max - kDefaultRingtoneCutMinDuration;
//        }
//    } else {
//        //change min
//        if (r.max - r.min <= kDefaultRingtoneCutMinDuration) {
//            r.max = r.min + kDefaultRingtoneCutMinDuration;
//        }
//    }
//    
//    
//    [slider setValue:r];
//    
//    rangeCurrent = r;
    
    
//	[self updateSliderLabels];
//    CGFloat duration = r.max - r.min;
    
//    //new max,min value
//    if (r.max != rangeCurrent.max) { //change max
//        slider.maximumValue = r.min + kRingtoneCutMaxDuration;
//    } else {
//        slider.maximumValue = r.min + kRingtoneCutMaxDuration;
//    }
//    
//    if (duration >= kRingtoneCutMaxDuration || duration <= kRingtoneCutMinDuration) {
//        return;
//    }
    
//    rangeCurrent = r;
//    NSLog(@"pass change range");
    
//    kRingtoneCutMinDuration
//    
    
    CGRect frame = viewSelection.frame;
    
    FloatRange r = slider.value;
    
    NSNumber *duration = [selectedItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    frame.origin.x = scrollRange.contentSize.width * (startRange + r.min) / [duration floatValue];
    frame.origin.y = 0.0f;
    frame.size.width = 3.0f +  scrollRange.contentSize.width * (r.max - r.min) / [duration floatValue];
    frame.size.height = scrollRange.frame.size.height;
    frame = [scrollRange convertRect:frame toView:self.view];
    viewSelection.frame = frame;
    NSLog(@"frame.size.height: %f", scrollRange.frame.size.height);
    NSLog(@"width: %f", frame.size.width);

    [self updateTimeLabels];
//    NSLog(@"sliderValueChanged");
}

- (IBAction)buttonPlayClicked:(id)sender; {    
    FloatRange r = slider.value;
    [player setCurrentPlaybackTime:r.min + startRange];
    
    if ([player playbackState] == MPMusicPlaybackStatePlaying) {
        [player pause];
    } else {
        [player play];
    }
    
}

- (void)didChangePlaybackState:(NSNotification *)notif;
{
//    if (notif && [notif object] != nil) {
        
        if ([player playbackState] == MPMusicPlaybackStatePlaying) {
            [buttonPlay setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
            
            [self startTimer];

//            imgviewPlayingIndi.hidden = NO;
            //enable slider
            slider.userInteractionEnabled = NO;
            scrollRange.userInteractionEnabled = NO;
            
        } else {
            [buttonPlay setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
            [self stopTimer];
            
            //disable slider
            imgviewPlayingIndi.hidden = YES;
            slider.userInteractionEnabled = YES;
            scrollRange.userInteractionEnabled = YES;

        }
//    }
}


- (void)startConvertCafToM4r;
{
    BOOL willContinue = YES;
    if ( ![TPAACAudioConverter AACConverterAvailable] ) {
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                     message:NSLocalizedString(@"Couldn't convert audio: Not supported on this device", @"")
                                    delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"OK", @""), nil] autorelease] show];
        willContinue = FALSE;
        goto handleFailToContinue;
//        return;
    }
    
    // Initialise audio session, and register an interruption listener, important for AAC conversion
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!delegate.isAudioSessionInitiated) {
        if (!checkResult(AudioSessionInitialize(NULL, NULL, interruptionListener, self), "initialise audio session") ) {
            [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                         message:NSLocalizedString(@"Couldn't initialise audio session!", @"")
                                        delegate:nil
                               cancelButtonTitle:nil
                               otherButtonTitles:NSLocalizedString(@"OK", @""), nil] autorelease] show];
            willContinue = FALSE;
            goto handleFailToContinue;
            //        return;
        } else {
            delegate.isAudioSessionInitiated = YES;
        }
    }
    
    
    // Set up an audio session compatible with AAC conversion.  Note that AAC conversion is incompatible with any session that provides mixing with other device audio.
    UInt32 audioCategory = kAudioSessionCategory_MediaPlayback;
    if ( !checkResult(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory), "setup session category") ) {
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                     message:NSLocalizedString(@"Couldn't setup audio category!", @"")
                                    delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"OK", @""), nil] autorelease] show];
        willContinue = FALSE;
        goto handleFailToContinue;
        //        return;
    } 
    
    NSArray *array = [lastConvertedCafName componentsSeparatedByString:@"/"];
    NSString *newM4rConvertedPath = lastConvertedCafName;
    
    if (array && [array count] > 0) {
        newM4rConvertedPath = [[array lastObject] stringByDeletingPathExtension];
    }
    
    newM4rConvertedPath = [newM4rConvertedPath stringByAppendingPathExtension:@"m4r"];
    newM4rConvertedPath = [CommonUtils pathForSourceFile:newM4rConvertedPath inDirectory:nil];
    NSLog(@"newM4rConvertedPath: %@", newM4rConvertedPath);
    
    NSLog(@"sourcefile: %@", lastConvertedCafName);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL fileExist = [fileMgr fileExistsAtPath:lastConvertedCafName];
    NSLog(@"fileExist: %d", fileExist);
    

//    if (audioConverter) {
//        audioConverter.delegate = nil;
//        [audioConverter release];
//        audioConverter = nil;
//        
//    }
    
    if (audioConverter == nil) {
        audioConverter = [[TPAACAudioConverter alloc] initWithDelegate:self 
                                                                source:lastConvertedCafName
                                                           destination:newM4rConvertedPath];
        
    }
    
    [audioConverter start];

handleFailToContinue:
    if (!willContinue) {
        [DSBezelActivityView removeViewAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.isConverting = FALSE;
    }
    

}


- (IBAction)buttonConvertClicked:(id)sender;
{
    [self startRecordingConvert];
    
}



- (void)startTimer;
{
    if (![timerLimit isValid]) {
        timerLimit = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer;
{
    if ([timerLimit isValid]) {
        [timerLimit invalidate];
        timerLimit = nil;
    }
    
    [player stop];

}

- (void)timerTick;
{
    CGFloat currentTime = player.currentPlaybackTime;
    
    FloatRange r = slider.value;
    
    NSNumber *duration = [selectedItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    CGRect playingFrame = imgviewPlayingIndi.frame;
        
    playingFrame.origin.x = scrollRange.contentSize.width * currentTime / [duration floatValue];
    imgviewPlayingIndi.frame = playingFrame;
    
    if (imgviewPlayingIndi.hidden) {
        imgviewPlayingIndi.hidden = FALSE;
    }
    if (currentTime >= startRange + r.max - 1.0f) {
        [self stopTimer];
    }
    
    
}


// record current playing item
- (void) startRecordingConvert;
{
    BOOL convertResult = TRUE;
    [player pause];
    [buttonPlay setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
    
    
    //start animation
    [DSBezelActivityView newActivityViewForView:self.navigationController.navigationBar.superview withLabel:@"Converting ..." width:160];
    
//    [CommonUtils startIndicatorDisableViewController:self];
    
    // set up an AVAssetReader to read from the iPod Library
	NSURL *assetURL = [selectedItem valueForProperty:MPMediaItemPropertyAssetURL];
	AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
	NSError *assetError = nil;
	AVAssetReader *assetReader = [[AVAssetReader assetReaderWithAsset:songAsset
                                                                error:&assetError]
								  retain];
	if (assetError) {
		NSLog (@"error: %@", assetError);
        convertResult = FALSE;
        goto endHandler;
		return;
	}
	
    
	AVAssetReaderOutput *assetReaderOutput = [[AVAssetReaderAudioMixOutput 
                                               assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                               audioSettings: nil]
											  retain];
    
    
	if (! [assetReader canAddOutput: assetReaderOutput]) {
		NSLog (@"can't add reader output... die!");
        convertResult = FALSE;
        goto endHandler;
		return;
	}
	[assetReader addOutput: assetReaderOutput];
	
    NSString *exportPath = [[self urlPathForRecord] retain];
    NSLog(@"exportPath: %@",exportPath);
    NSURL *exportURL = [NSURL fileURLWithPath: exportPath];
    NSLog(@"exportURL: %@",exportURL);
	AVAssetWriter *assetWriter = [[AVAssetWriter assetWriterWithURL:exportURL
                                                           fileType:AVFileTypeCoreAudioFormat
                                                              error:&assetError]
								  retain];
	if (assetError) {
		NSLog (@"error: %@", assetError);
        convertResult = FALSE;
        goto endHandler;
		return;
	}
    
    
	AudioChannelLayout channelLayout;
	memset(&channelLayout, 0, sizeof(AudioChannelLayout));
	channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
	NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey, 
									[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
									[NSNumber numberWithInt:2], AVNumberOfChannelsKey,
									[NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
									[NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
									[NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
									[NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
									[NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
									nil];
	AVAssetWriterInput *assetWriterInput = [[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                               outputSettings:outputSettings]
											retain];
    
	if ([assetWriter canAddInput:assetWriterInput]) {
		[assetWriter addInput:assetWriterInput];
	} else {
		NSLog (@"can't add asset writer input... die!");
        convertResult = FALSE;
        goto endHandler;
		return;
	}
	
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

endHandler:
    if (!convertResult) {
        [DSBezelActivityView removeViewAnimated:YES];
        delegate.isConverting = NO;
        
        return;
    }
    
    
    delegate.isConverting = YES;
    
	assetWriterInput.expectsMediaDataInRealTime = NO;
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    NSLog(@"soundTrack.naturalTimeScale: %d",soundTrack.naturalTimeScale);
    
    FloatRange r = slider.value;
    assetReader.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(r.min, soundTrack.naturalTimeScale), 
                                            CMTimeMakeWithSeconds(r.max - r.min, soundTrack.naturalTimeScale)); // 2 params: start time, duration
    
    
	[assetWriter startWriting];
	[assetReader startReading];
    
	
    
	CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
	[assetWriter startSessionAtSourceTime: startTime];
	
	dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
	[assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue 
											usingBlock: ^ 
	 {
		 // NSLog (@"top of block");
		 while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
             } else {
                 // done!
                 [assetWriterInput markAsFinished];
                 
                 
                 [assetWriter finishWriting];
                 [assetReader cancelReading];
   
                 
                 // release a lot of stuff
                 [assetReader release];
                 [assetReaderOutput release];
                 [assetWriter release];
                 [assetWriterInput release];                 
                 
                 NSLog(@"done converting caf, now convert to m4r");
                 [self startConvertCafToM4r];
             }
         }
         
	 }];
    
//    [CommonUtils stopIndicatorDisableViewController:self];
    
}

// Return unique path for record file to be stored in Documents Folder
- (NSString *) urlPathForRecord;
{
    NSString *fileName = [selectedItem valueForProperty:MPMediaItemPropertyTitle];
    
    int i = 0;
    
    NSString *uniquePath = [CommonUtils pathForSourceFile:[NSString stringWithFormat:@"%@.caf", fileName] inDirectory:kTempFolderConvert];
    //[NSString stringWithFormat:@"%@/%@.caf",DOCUMENTS_PATH,fileName];
    
    while ([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
    {
        uniquePath = [CommonUtils pathForSourceFile:[NSString stringWithFormat:@"%@-%d.caf", fileName, ++i] inDirectory:kTempFolderConvert];
        
        //[NSString stringWithFormat:@"%@/%@-%d.caf", DOCUMENTS_PATH, fileName, ];
    }
    
    NSLog(@"uniquePath: %@", uniquePath);
    
    lastConvertedCafName = [uniquePath copy];
	return uniquePath;
}




#pragma mark - Audio converter delegate

-(void)AACAudioConverter:(TPAACAudioConverter *)converter didMakeProgress:(CGFloat)progress {
//    NSLog(@"progress: %f", progress);
}

-(void)AACAudioConverterDidFinishConversion:(TPAACAudioConverter *)converter {
    
    audioConverter = nil;
    
    //delete temp file
    NSArray *arr = [lastConvertedCafName componentsSeparatedByString:@"/"];
    NSString *fileToDelete = lastConvertedCafName;
    if (arr && [arr count] > 0) {
        fileToDelete = [arr lastObject];
    }
    [[RingtoneHelpers defaultHelper]deleteTempConvert:fileToDelete];
    
//    [CommonUtils stopIndicatorDisableViewController:self];
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isConverting = FALSE;
    
    //back
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)AACAudioConverter:(TPAACAudioConverter *)converter didFailWithError:(NSError *)error {
    [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                 message:[NSString stringWithFormat:NSLocalizedString(@"Couldn't convert audio: %@", @""), [error localizedDescription]]
                                delegate:nil
                       cancelButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"OK", @""), nil] autorelease] show];

    audioConverter = nil;
    
    //delete temp file
    NSArray *arr = [lastConvertedCafName componentsSeparatedByString:@"/"];
    NSString *fileToDelete = lastConvertedCafName;
    if (arr && [arr count] > 0) {
        fileToDelete = [arr lastObject];
    }
    [[RingtoneHelpers defaultHelper]deleteTempConvert:fileToDelete];
    
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isConverting = FALSE;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = [selectedItem valueForProperty:MPMediaItemPropertyTitle];
    self.title = title;
    
    
    NSNumber *duration = [selectedItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    //create slider
    CGRect frame;
//	frame.origin = CGPointZero;
    frame.origin = CGPointMake(5.0f, 0.0f);
    
    slider = [[ASRangeSlider alloc] initWithSpectrum:FloatRangeMake(0.0, durationPerScroll)];
	[slider setThumbBackgroundImage:[UIImage imageNamed:@"SliderButton.png"]];
    [slider setTrackBackgroundImage:[UIImage imageNamed:@"SliderBk_dummy.png"]];
	frame.size =  CGSizeMake(sliderPlaceHolder.frame.size.width - 10.0f, sliderPlaceHolder.frame.size.height);  //sliderPlaceHolder.frame.size;
	slider.frame = frame;
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	slider.activeAreaView.backgroundColor =  [UIColor clearColor] ; //[UIColor colorWithRed:(180.0/256.0) green:(24.0/256.0) blue:(34.0/256.0) alpha:0.5];
    [sliderPlaceHolder addSubview:slider];
	[slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

//    CGFloat minValue = (kDefaultRingtoneCutStartPoint > [duration floatValue]) ? 0 : kDefaultRingtoneCutLength;
//    CGFloat maxValue = (kDefaultRingtoneCutLength > [duration floatValue]) ? [duration floatValue] : kDefaultRingtoneCutLength;
    slider.value = FloatRangeMake(5.0, 5.0 + kRingtoneCutMinDuration);
    
//    [self updateSliderLabels];
    
    
    //init player
    player = [MPMusicPlayerController applicationMusicPlayer];
//    player.repeatMode = MPMovieRepeatModeNone;    
    
    [player beginGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangePlaybackState:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:player];
    
    MPMediaItemCollection *collection = [[MPMediaItemCollection alloc]initWithItems:[NSArray arrayWithObject:selectedItem]];
    [player setQueueWithItemCollection:collection];
    
    [collection release];
    
    //update duration
    labelEnd.text = [CommonUtils convertToDateTimeFrom:[duration floatValue]];
    
    //ratio: slideWidth px: 60s
    // ? px: duration -> duration * slideWidth / 60;
    scrollRange.clipsToBounds = NO;
    UIImage *imgWave = [UIImage imageNamed:@"frequence_mask.png"];
    CGSize sizeWave = imgWave.size;
    
    //calculate needed content width
    CGFloat neededContentWidth = [duration floatValue] * scrollRange.frame.size.width / durationPerScroll;
    NSLog(@"neededContentWidth: %f", neededContentWidth);
    scrollRange.contentSize = CGSizeMake(neededContentWidth, scrollRange.frame.size.height);
    
    //add image to scrollview
    
    CGFloat scrollContentWidth = 0.0f;
    while (scrollContentWidth < neededContentWidth) {        
        UIImageView *imgViewWave = [[UIImageView alloc]initWithImage:imgWave];
        imgViewWave.contentMode = UIViewContentModeLeft;
        imgViewWave.clipsToBounds = YES;
        CGFloat imgviewWidth = sizeWave.width;
        
        if (scrollContentWidth + sizeWave.width > neededContentWidth) {
            imgviewWidth = neededContentWidth - scrollContentWidth;
             
//            scrollContentWidth = neededContentWidth;
        }
        
        imgViewWave.frame = CGRectMake(scrollContentWidth, 0.0f, imgviewWidth, scrollRange.frame.size.height);

        //        [scrollRange insertSubview:imgViewWave belowSubview:viewSelection];
        [scrollRange addSubview:imgViewWave];
        
        [imgViewWave release];
        
        
        scrollContentWidth += imgviewWidth;
    }
//    [scrollRange bringSubviewToFront:viewSelection];
    
    [self.view addSubview:viewSelection];
    
    startRange = 0;
    endRange = durationPerScroll;
    
//    [self updateTimeLabels];
    [self sliderValueChanged:slider];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (player) {
        [player stop];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
       
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    if (player) {
        [player stop];
        [player setNowPlayingItem:nil];
        
        [player endGeneratingPlaybackNotifications];
    }
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}


@end
