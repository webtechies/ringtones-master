
#import "MessageComposerViewController.h"
#import "Constants.h"
#import "CommonUtils.h"

//Description: check mail client before display UI
@interface MessageComposerViewController (private)

- (void)showMailPicker;
- (void)displayMailComposerSheet;
- (BOOL)checkMailPicker;
- (void)setMailSubject:(NSString *)subject andAttachFilename:(NSString *)fileName;
- (void)setAttachFile:(NSString *)fileName;


@end


@implementation MessageComposerViewController
@synthesize mailSubject, attachFilename, mailBody;


-(id)initwithAttachFileName:(NSString *)fileName;
{
    self = [super init];
    
    if (self) {
        [self setAttachFile:fileName];
    }
    
    return self;
}

- (void)setMailSubject:(NSString *)subject andAttachFilename:(NSString *)fileName;
{
    F_RELEASE(mailSubject);
    mailSubject = [subject copy];
    
    F_RELEASE(attachFilename);
    attachFilename = [fileName copy];
}

- (void)setAttachFile:(NSString *)fileName;
{
    [self setMailSubject:[NSString stringWithFormat:kEmailTemplate, fileName] andAttachFilename:fileName];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if ([self checkMailPicker] == YES)
	{
		[self showMailPicker];
	}
}

//Description: check mail client before display UI
- (BOOL) checkMailPicker
{
	BOOL result = YES;
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	
	if (mailClass != nil) 
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail] == NO) 
		{
			result = NO;
			
			UIAlertView *alertView = 
			[[UIAlertView alloc] initWithTitle:@"Error"
									   message:@"You should configure the mail client"
									  delegate:self
							 cancelButtonTitle:@"OK"
							 otherButtonTitles:nil];
			
			[alertView show];
			[alertView release];
		}
	}
	return result;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}


// Support all orientations except for portrait upside-down.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark -
#pragma mark Show Mail/SMS picker

-(void)showMailPicker
{
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device 
	// can send emails.	Display feedback message, otherwise.
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	
	if (mailClass != nil) 
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) 
		{
			[self displayMailComposerSheet];
		}
	}
}

#pragma mark -
#pragma mark Compose Mail/SMS

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayMailComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
//    picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    //load navbar background
    UIImageView *bkgNav = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navbar.png"]] autorelease];
    CGRect frame = bkgNav.frame;
    frame.size.height = picker.navigationBar.frame.size.height;
    frame.origin.x = 0;
    [bkgNav setFrame:frame];
    
    [picker.navigationBar insertSubview:bkgNav atIndex:([CommonUtils isIOS5OrGreater]) ? 1 : 0];
    
    
    if (mailSubject) {
        [picker setSubject:mailSubject];
    }    
    

	// Fill out the email body text
	if (mailBody == nil) {
        mailBody = [NSString stringWithFormat:@""];
    }
	[picker setMessageBody:mailBody isHTML:YES];
    
    if (attachFilename) {        
        //set attachment
        NSData *dataToSend = [NSData dataWithContentsOfFile:[CommonUtils pathForSourceFile:attachFilename inDirectory:nil]];
        [picker addAttachmentData:dataToSend mimeType:@"audio/aac" fileName:attachFilename];
    } else {
        [picker setSubject:mailSubject];
        
    }
	
	[self presentModalViewController:picker animated:YES];

	[picker release];
}

#pragma mark -
#pragma mark Dismiss Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the 
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	
	if ([self checkMailPicker] == NO)
	{
		return;
	}
	
	switch (result)
	{
		case MFMailComposeResultSent:
		{
			
			
		}
			break;
		case MFMailComposeResultFailed:
		{
			
			
		}
			break;
		case MFMailComposeResultCancelled:
		{
			
		}
			break;
		case MFMailComposeResultSaved:
		{
			
		}
			break;
			
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -
#pragma mark Memory management
- (void)dealloc 
{
	[super dealloc];
}

@end
