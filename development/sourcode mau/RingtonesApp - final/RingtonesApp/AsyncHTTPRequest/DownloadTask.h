//
//  DownloadTask.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadTask : NSObject {
    NSString *key;
	NSString *url;

}


@property(copy) NSString *key;
@property(copy) NSString *url;
//@property(nonatomic) short type;

- (id)initWithKey:(NSString *)aKey 
		URLString:(NSString *)aURL; 


@end
