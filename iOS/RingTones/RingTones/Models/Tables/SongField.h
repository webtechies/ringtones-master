//
//  SongField.h
//  RingTones
//
//  Created by VinhTran on 12/22/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongField : NSObject
{
	NSString *rowid;
	NSString *name;
    NSString *date;
    NSString *duration;
    NSString *path;
    NSString *type;
	NSString *url;
	NSString *other2;
	NSString *other3;
}

@property (nonatomic, retain) NSString *rowid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *other2;
@property (nonatomic, retain) NSString *other3;


@end
//CREATE TABLE "Song" ("name" TEXT, "date" TEXT, "duration" TEXT, "path" TEXT, "type" TEXT DEFAULT 0, "other1" TEXT, "other2" TEXT, "other3" TEXT)