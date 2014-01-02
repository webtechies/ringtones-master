//
//  DownloaderManager.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloaderManager.h"

#import "Constants.h"
#import "CommonUtils.h"
#import "DatabaseManager.h"


static DownloaderManager *_defaultManager;
@implementation DownloaderManager
@synthesize taskQueue;
@synthesize taskContainer, tasks;
@synthesize shouldStopThread, isStoppedThread;
@synthesize networkQueue;



//
//- (id)init
//{
//	if (self = [super init])
//	{
//		taskContainer = [NSMutableArray new];
//		taskQueue = [NSOperationQueue new];
//		tasks = [[NSMutableArray alloc] init];
//	}
//	return self;
//}
//
//- (void)dealloc
//{
//	[tasks release];
//	[taskContainer release];
//	[taskQueue release];
//	[super dealloc];
//}
//
//+ (id)allocWithZone:(NSZone *)zone
//{
//	@synchronized(self)
//	{
//		if (_defaultManager == nil)
//		{
//			_defaultManager = [super allocWithZone:zone];
//			return _defaultManager;
//		}
//	}
//	return nil;
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//	return self;
//}
//
//- (id)retain
//{
//	return self;
//}
//
//- (unsigned)retainCount
//{
//	return UINT_MAX;
//}
//
//- (id)autorelease
//{
//	return self;
//}
//




- (void)firstInitQueue;
{
    // Stop anything already in the queue before removing it
    [[_defaultManager networkQueue] cancelAllOperations];
    
    // Creating a new queue each time we use it means we don't have to worry about clearing delegates or resetting progress tracking
    [_defaultManager setNetworkQueue:[[ASINetworkQueue alloc]init]];
    [[_defaultManager networkQueue] setDelegate:self];
    [[_defaultManager networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
    [[_defaultManager networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
    [[_defaultManager networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    
    [[_defaultManager networkQueue]setShouldCancelAllRequestsOnFailure:NO];
    
    [[_defaultManager networkQueue]setMaxConcurrentOperationCount:kMaxConcurrentDownloading];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationStartDownloadRingtone object:nil];
    
    
}


+ (DownloaderManager *)defaultManager;
{
    if (_defaultManager == nil) {
        _defaultManager = [[DownloaderManager alloc]init];
        
//        [_defaultManager firstInitQueue];
        
    }
    
    return _defaultManager;
}

- (void)addRequestToQueueFromDict:(NSDictionary *)dict;
{
    if ([_defaultManager networkQueue] == nil || [[_defaultManager networkQueue] requestsCount] == 0) {
        [_defaultManager firstInitQueue];
    }
    
    
    NSString *url = [dict objectForKey:@"link"];
    NSString *fileName = url;
    
    NSArray *arr = [url componentsSeparatedByString:@"/"];
    if (arr != nil && [arr count] > 0) {
        fileName = [arr objectAtIndex:[arr count] - 1];
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *path = [CommonUtils pathForSourceFile:fileName inDirectory:nil];
    
    NSLog(@"path: %@", path);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUserInfo:dict];
    [request setDownloadDestinationPath:path];
    [request setDownloadProgressDelegate:self];
    [request setAllowResumeForFileDownloads:YES];
    [request setTimeOutSeconds:kTimeoutDownloadRingtone];
    [[_defaultManager networkQueue] addOperation:request];
    
    [[_defaultManager networkQueue] go];
    
    
}

- (void)addRequestToQueue:(NSString *)url progressDelegate:(UIProgressView *)progressDelegate;
{
    if ([_defaultManager networkQueue] == nil || [[_defaultManager networkQueue] requestsCount] == 0) {
        [_defaultManager firstInitQueue];
    }
    
    NSString *fileName = url;
    
    NSArray *arr = [url componentsSeparatedByString:@"/"];
    if (arr != nil && [arr count] > 0) {
        fileName = [arr objectAtIndex:[arr count] - 1];
    }
    
    NSString *path = [CommonUtils pathForSourceFile:fileName inDirectory:nil];
    
    NSLog(@"path: %@", path);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setShowAccurateProgress:YES];
    [request setDownloadDestinationPath:path];
    [request setDownloadProgressDelegate:progressDelegate];
    [[_defaultManager networkQueue] addOperation:request];
    
    [[_defaultManager networkQueue] go];
    
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoneDownloadRingtone object:nil];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // You could release the queue here if you wanted
    if ([[_defaultManager networkQueue] requestsCount] == 0) {
        
        // Since this is a retained property, setting it to nil will release it
        // This is the safest way to handle releasing things - most of the time you only ever need to release in your accessors
        // And if you an Objective-C 2.0 property for the queue (as in this example) the accessor is generated automatically for you
//        [_defaultManager setNetworkQueue:nil];
    }
    
    //save count downloaded
//    NSNumber *countDownloaded = [[NSUserDefaults standardUserDefaults]objectForKey:kDownloadedCount];
//    NSInteger newCount;
//    if (countDownloaded == nil) {
//        countDownloaded = [NSNumber numberWithInt:0];
//    }
//    
//    newCount = [countDownloaded intValue] + 1;
//    countDownloaded = [NSNumber numberWithInt:newCount];
//    
//    [[NSUserDefaults standardUserDefaults]setObject:countDownloaded forKey:kDownloadedCount];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    //send down request to increase down count
    NSDictionary *dict = [request userInfo];
    NSString *url = [NSString stringWithFormat:SERVER_API_INCREASE_DOWN, [[dict objectForKey:@"id"]intValue]];
    ASIHTTPRequest *requestDown = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [requestDown startAsynchronous];
    [requestDown release];

    
//    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoneDownloadRingtone object:nil];

    
    /*
    
    //save request to localDB
    
    NSString *url = [[request url]absoluteString];
    NSString *name = url;
    NSArray *array = [name componentsSeparatedByString:@"/"];
    if (array != nil && [array count] > 0) {
        name = [array objectAtIndex:[array count] - 1];
    }
    
    CGFloat totalSize = [request contentLength];
    CGFloat createdDate = [[NSDate date]timeIntervalSince1970];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:name forKey:@"title"];
    [dict setObject:@"4" forKey:@"rate"];
    [dict setObject:[NSString stringWithFormat:@"%f", totalSize] forKey:@"size"];
    [dict setObject:[NSString stringWithFormat:@"%f", createdDate] forKey:@"createdDate"];
    [dict setObject:@"37" forKey:@"duration"];
    
    NSError *error = nil;
    [[DatabaseManager defaultManager]insertRingtoneToDB:dict error:&error];
    [dict release];
    if (error) {
        NSLog(@"error insert to db: %@", [error localizedDescription]);
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationCompleteOneDownloadRingtone object:request];

     */
    
    //... Handle success
    NSLog(@"Request finished");
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Count queue: %d", [[_defaultManager networkQueue] operationCount]);
    // You could release the queue here if you wanted
//    if ([[_defaultManager networkQueue] requestsCount] == 0) {
//        [_defaultManager setNetworkQueue:nil];
//    }
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoneDownloadRingtone object:nil];
    
    //... Handle failure
    NSLog(@"Request failed: %@", [[request error]localizedDescription]);
}


- (void)queueFinished:(ASINetworkQueue *)queue
{
    // You could release the queue here if you wanted
    if ([[_defaultManager networkQueue] requestsCount] == 0) {
        [_defaultManager setNetworkQueue:nil];
    }
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoneDownloadRingtone object:nil];

    
    NSLog(@"Queue finished");
}

#pragma mark 
#pragma mark Execute thread methods
- (void)executePerformWithTarget:(id)target 
						selector:(SEL)sel 
					  withObject:(id)object
{
	[target performSelector:sel 
				 withObject:object];
}

- (void)executeOnMainThreadWithTarget:(id)target 
							 selector:(SEL)sel 
								 lock:(BOOL)lock
{
	[target performSelectorOnMainThread:sel 
							 withObject:nil 
						  waitUntilDone:lock];
}

- (void)executeOnMainThreadWithTarget:(id)target 
							 selector:(SEL)sel 
							   object:(id)object 
								 lock:(BOOL)lock
{
	[target performSelectorOnMainThread:sel 
							 withObject:object 
						  waitUntilDone:lock];
}

- (void)executeThreadWithTarget:(id)target 
					   selector:(SEL)sel
{
	[NSThread detachNewThreadSelector:sel 
							 toTarget:target 
						   withObject:nil];
}

- (void)executeThreadWithTarget:(id)target 
					   selector:(SEL)sel 
					 withObject:(id)object
{
	[NSThread detachNewThreadSelector:sel 
							 toTarget:target 
						   withObject:object];
}

#pragma mark 
#pragma mark FUNCTION METHODS
- (void)startNewTaskWithTarget:(id)sender
					  selector:(SEL)callbackFunc 
						object:(id)object
{
	NSInvocationOperation *op = 
	[[NSInvocationOperation alloc] initWithTarget:sender
										 selector:callbackFunc
										   object:object];
	[self.taskQueue addOperation:op];
	[op release];	
}

- (BOOL)isContainerEmpty
{
	BOOL isSuccess = FALSE;
	@synchronized(self)
	{
		if([taskContainer count] == 0)
		{
			isSuccess = TRUE;
		}
	}
	return isSuccess;
}

- (void)putDownTask:(id)key
{
	@synchronized(self)
	{
		if([taskContainer lastObject] != nil && key)
		{
			[taskContainer addObject:key];
		}
	}
}
- (void)priorTask:(id)task
{
	//printLog(@"priorTask_S");
	if(taskContainer != nil
	   && [taskContainer count] > 0)
	{
		DownloadTask * atask = [taskContainer objectAtIndex:0];
		if([atask.key isEqualToString:((DownloadTask*)task).key] == YES)
		{
			//printLog(@"This task is on position 0, so do nothing");
			//printLog(@"a");
			return;
		}
	}
	for(DownloadTask * atask in taskContainer)
	{
		if([atask.key isEqualToString:((DownloadTask*)task).key] == YES)
		{
			//printLog(@"isExist == YES, so remove it, after that, insert it on position 0");
			//printLog(@"\tb");
			[taskContainer removeObject:atask];
			break;
		}
	}	
	[taskContainer insertObject:task 
						atIndex:0];
	//printLog(@"priorTask_E");
}

- (void)pushTask:(id)task
{
	//	Change By VuNTH _S
	//	Time:2011/05/12
	//	Reason: Fix bug improve performance update thumbnail on UIKatamary
	//	Description: check if(exist key) do not push it, else push it in to task.
	@synchronized(self)
	{
		if(taskContainer)
		{
			BOOL agree =  YES;
			for(DownloadTask * atask in taskContainer)
			{
				if([atask.key isEqualToString:((DownloadTask*)task).key] == YES)
				{
					agree = NO;
					break;
				}
			}
			if(agree == YES)
			{
				NSLog(@"Not exist %@, so push it",((DownloadTask*)task).key);
				[taskContainer insertObject:task 
									atIndex:0];
			}
			else
			{
				NSLog(@"Exist %@, so do not push it",((DownloadTask*)task).key);
			}
		}
		//		if(taskContainer)
		//		{
		//			[taskContainer insertObject:task 
		//								atIndex:0];
		//		}
	}
	//	Change By VuNTH _E
}

- (id)popTask
{
	@synchronized(self)
	{
		if([taskContainer count] > 0)
		{
			//last in , first out
			id result = [taskContainer objectAtIndex:0];
			[[result retain] autorelease];
			[taskContainer removeObjectAtIndex:0];
			return result;
			
			//first in, first out
			//			id result = [taskContainer objectAtIndex:[taskContainer count] - 1];
			//			[[result retain] autorelease];
			//			[taskContainer removeObjectAtIndex:[taskContainer count] - 1];
			//			return result;			
		}
	}
	return nil;
}



@end
