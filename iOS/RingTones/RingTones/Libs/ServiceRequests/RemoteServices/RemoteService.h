//
//  RemoteService.h
//  Snooty
//
//  Created by Tran Thien Khiem on 12/12/12.
//  Copyright (c) 2012 Phan Xuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const SERVER_ROOT;
UIKIT_EXTERN NSString *const GATEWAY;
UIKIT_EXTERN NSString *const APP;
UIKIT_EXTERN NSString *const DEBUG_SERVICES;

@protocol RemoteServiceDelegate <NSObject>

@optional
//- (void) getRingtonesByKeywordFinished:(NSString *) data;
@end
@interface RemoteService : NSObject
{
    id _delegate;
    NSString *_serviceName;
    NSString *_attachedFile;
}

// The delegate - event handler
@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) NSString *serviceName;
@property(nonatomic, retain) NSString *attachedFile;

- (id) init;
- (id) initWithName:(NSString *) name;
- (void) invokeMethod: (NSString *) methodName params:(NSArray *) arguments;
+ (void) registerSession: (NSString *) sessionId;

@end
