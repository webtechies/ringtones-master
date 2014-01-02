//
//  DownloaderManager.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@interface DownloaderManager : NSObject <ASIProgressDelegate>{

    NSMutableArray *taskContainer;
	NSOperationQueue *taskQueue;
	NSMutableArray *tasks;
	
	BOOL shouldStopThread;
	BOOL isStoppedThread;
    
    ASINetworkQueue *networkQueue;
}

@property (nonatomic, retain) NSMutableArray *taskContainer;
@property (nonatomic, retain) NSOperationQueue *taskQueue;
@property (nonatomic, retain) NSMutableArray *tasks;
@property (assign)			  BOOL shouldStopThread;
@property (assign)			  BOOL isStoppedThread;

@property (retain) ASINetworkQueue *networkQueue;

+ (DownloaderManager *)defaultManager;
- (void)addRequestToQueueFromDict:(NSDictionary *)dict;
- (void)addRequestToQueue:(NSString *)url progressDelegate:(UIProgressView *)progressDelegate;




- (void)startNewTaskWithTarget:(id)sender
					  selector:(SEL)callbackFunc 
						object:(id)object;

- (void)pushTask:(id)task;
- (void)priorTask:(id)task;
- (id)popTask;
- (BOOL)isContainerEmpty;
- (void)putDownTask:(id)task;

// garbage collector
#pragma mark 
#pragma mark Garbage collector
//- (void)addTask:(DownloadTask *)task;
//- (void)startGarbageCollector;

#pragma mark 
#pragma mark Execute thread methods
- (void)executePerformWithTarget:(id)target 
						selector:(SEL)sel 
					  withObject:(id)object;

- (void)executeOnMainThreadWithTarget:(id)target 
							 selector:(SEL)sel 
								 lock:(BOOL)lock;
- (void)executeOnMainThreadWithTarget:(id)target 
							 selector:(SEL)sel 
							   object:(id)object 
								 lock:(BOOL)lock;

- (void)executeThreadWithTarget:(id)target 
					   selector:(SEL)sel;

- (void)executeThreadWithTarget:(id)target 
					   selector:(SEL)sel 
					 withObject:(id)object;





@end
