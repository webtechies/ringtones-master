//
//  FileManager.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^ReadFileBlock)(NSArray *);

@interface FileManager : NSObject


+ (void) readFileName:(NSString *) filename isMakeObject:(BOOL) makeObject completionBlock:(ReadFileBlock) block;


@end
