//
//  DownloadTask.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadTask.h"

@implementation DownloadTask
@synthesize key, url;

- (id)initWithKey:(NSString *)aKey 
		URLString:(NSString *)aURL 
{
	if(self = [super init])
	{
		self.key = aKey;
		self.url = aURL;
	}
	return self;
}

- (void)dealloc 
{
	[key release];
	[url release];
	[super dealloc];
}




@end
