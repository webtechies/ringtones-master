

////SearchHistoryField.m 
//  Project 
// 
//  Created by TeamiOS on 2013-12-21 17:27:59 +0000. 
//
// 

#import "SearchHistoryField.h"

@implementation SearchHistoryField
@synthesize rowid;
@synthesize searchKey;
@synthesize other1;
@synthesize other2;
@synthesize other3;


-(void) dealloc
{
	[rowid release];
	[searchKey  release];
	[other1  release];
	[other2  release];
	[other3  release];

	[super  dealloc];
}

@end