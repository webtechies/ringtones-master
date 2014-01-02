//
//  HelpViewController.h
//  RingTones
//
//  Created by Nguyen Khoi Nguyen on 12/26/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController
{
    
    IBOutlet UIView *view_Btn_NavBack;
    __weak IBOutlet UILabel *label_PushView_Nam;
    __weak IBOutlet UIWebView *webView_Help;
    
}
- (IBAction)btn_PopToView_Tapped:(id)sender;
@property (nonatomic, assign) BOOL isHelp;
@end
