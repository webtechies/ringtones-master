//
//  FileManager.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "FileManager.h"
#import "AppRecord.h"

@implementation FileManager



+ (void) readFileName:(NSString *) filename isMakeObject:(BOOL)makeObject completionBlock:(ReadFileBlock) block
{
    NSString *pathfile = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSArray *listData = [NSArray arrayWithContentsOfFile:pathfile];
    
    if (makeObject)
        listData = (NSArray *)[self convertToObjectAppRecord:listData];
    
    block(listData);
}


+ (NSArray *) convertToObjectAppRecord:(NSArray *) listData
{
    __block NSMutableArray *datas = [NSMutableArray array];
    
    [listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSDictionary *dictionary = (NSDictionary *) obj;
        
        AppRecord *appRecord = [[AppRecord alloc] init];
        [appRecord setAppIcon:nil];
        [appRecord setAppName:[dictionary valueForKey:@"name_app"]];
        [appRecord setDescription:[dictionary valueForKey:@"description_app"]];
        [appRecord setAppURLString:[dictionary valueForKey:@"icon_app"]];
        [appRecord setAppURLAppStoreString:[dictionary valueForKey:@"url_app"]];

        [datas addObject:appRecord];
        [appRecord release];
        
        
    }];
    
    return datas;
}



@end
