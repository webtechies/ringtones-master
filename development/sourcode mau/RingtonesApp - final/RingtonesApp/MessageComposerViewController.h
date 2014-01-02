//
//  MessageComposerViewController.h
//  TimeBoxing
//
//  Created by Dat Nguyen on 7/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MessageComposerViewController : UIViewController<MFMailComposeViewControllerDelegate> {
    NSString *mailSubject;
    NSString *attachFilename;
    NSString *mailBody;
}

@property(nonatomic, copy) NSString *mailSubject;
@property(nonatomic, copy) NSString *attachFilename;
@property(nonatomic, copy) NSString *mailBody;

-(id)initwithAttachFileName:(NSString *)fileName;

- (void)setMailSubject:(NSString *)mailSubject andAttachFilename:(NSString *)fileName;

- (void)setAttachFilename:(NSString *)fileName;

@end
