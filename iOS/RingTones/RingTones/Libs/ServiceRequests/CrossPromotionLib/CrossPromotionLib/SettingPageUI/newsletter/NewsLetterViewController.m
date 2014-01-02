//
//  NewsLetterViewController.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/11/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "NewsLetterViewController.h"
#import "NewsLetterCell.h"
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"


#define kNumberOfRowsInput 2




@interface NewsLetterViewController ()
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation NewsLetterViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - Subscribled


-(IBAction)subscriblePressed:(id)sender
{
    NSString *emailstr = @"";
    NSString *name = @"";
    
    
    for (int i =0; i < kNumberOfRowsInput; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        NewsLetterCell *cell  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath];
        
        if (i == 1)
            emailstr = cell.textField.text;
        else if (i == 0){
            name = cell.textField.text;
        }
        
    }
    
    
    //--track empty info
    if (emailstr.length <= 0 || name.length <= 0)
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Enter email or name required" message:@"Please fill name and email and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertview.tag = 3;
        [alertview show];
        [alertview release];
        
        return;
    }
    
    
    //--valid email
    BOOL isValidEmail = [self validateEmailWithString:emailstr];
    
    if (!isValidEmail)
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Valid Email Required" message:@"Please enter aa valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertview.tag = 1;
        [alertview show];
        [alertview release];
        
        return;
    }
    
    // button
    [sender setEnabled:NO];
    
    
    // get product name
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
    
    //
    [self.activityIndicatorView startAnimating];
    
    //
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    NewsLetterCell *cell1  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath];
    NewsLetterCell *cell2  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath2];
    
    [cell1.textField setEnabled:NO];
    [cell2.textField setEnabled:NO];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://192.241.128.84/service/receiveemail"];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:emailstr forKey:@"email"];
    [request setPostValue:prodName forKey:@"productname"];
    [request setPostValue:name forKey:@"name"];

    [request setCompletionBlock:^{
        
        // Use when fetching text data
        NSString *responseString = [[request responseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        SBJsonParser *jsonParse = [[SBJsonParser alloc] init];
        NSDictionary *dictionary = [jsonParse objectWithString:responseString];
        
       
        
       /*13-09-14 22:48:48.633 Demo[6929:c07] dictionary: {
            message = "Save email success";
            status = 1; 
        */
        
        [self.activityIndicatorView stopAnimating];
        
        BOOL status = [[dictionary valueForKey:@"status"] boolValue];
        if (status)
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", emailstr, @"email", prodName,  @"productname", nil];
            [defaults setValue:dictionary forKey:@"newsletter_data"];
            [defaults synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Subscribled" message:@"We will get back to you through email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
            [alert release];
        }
        
        
        
    }];
    
    
    [request setFailedBlock:^{
        
        NSError *error = [request error];
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
        [alertview release];
        
        [self.activityIndicatorView stopAnimating];
        
        [cell1.textField setEnabled:YES];
        [cell2.textField setEnabled:YES];
        
    }];
    
    
    [request startAsynchronous];
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag =  alertView.tag;
    
    if(tag == 1)
    {
        if (buttonIndex == 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            NewsLetterCell *cell  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath];
            [cell.textField becomeFirstResponder];
        }
    }else if (tag == 2)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



#pragma mark -  UITextField


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    NewsLetterCell *cell1  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath];
    NewsLetterCell *cell2  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath2];
    
    if (cell2.textField == textField){
        
        cell1.subscrible.enabled =  YES;
        
    }else{
        cell1.subscrible.enabled =  NO;
    }
    
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    NewsLetterCell *cell1  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath];
    NewsLetterCell *cell2  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath2];

    if (textField ==  cell1.textField)
    {
        [cell2.textField  becomeFirstResponder];
        
        return NO;
        
    }else if (textField == cell2.textField){
        
        
        //--send email
        [self performSelector:@selector(subscriblePressed:) withObject:nil];
        
        
        return NO;
    }
    
    return YES;
}




#pragma mark -  UITableView


-(void) initTableView
{
    if (!_nlTableView)
    {
        CGRect rect = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            rect.size.width = 500;
            rect.origin.x = ceil((self.view.frame.size.width - rect.size.width)/2);
            rect.origin.y = 80;
        }
        
        UITableViewStyle style = UITableViewStyleGrouped;
        
        _nlTableView = [[UITableView alloc] initWithFrame:rect style:style];
        [self.nlTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight];
        
        self.nlTableView.backgroundColor = [UIColor clearColor];
        self.nlTableView.backgroundView = nil;
        self.nlTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.nlTableView setDelegate:self];
        [self.nlTableView setDataSource:self];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            self.nlTableView.scrollEnabled =  NO;
        
        [self.view addSubview:self.nlTableView];
        
    }
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return kNumberOfRowsInput;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 3;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewsLetterCell";
    
    NewsLetterCell *cell = (NewsLetterCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[NewsLetterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                
                cell.labelTitle.text = @"Name";
                cell.textField.placeholder = @"John Appleseed";
                cell.subscrible.hidden =  YES;
                cell.textField.delegate =  self;
                cell.textField.returnKeyType = UIReturnKeyNext;
                
                
                break;
            case 1:
                
                
                cell.labelTitle.text = @"Email";
                cell.textField.placeholder = @"Example@gmail.com";
                cell.subscrible.hidden =  YES;
                cell.textField.delegate =  self;
                cell.textField.returnKeyType =  UIReturnKeySend;
                
                
                break;
                
            default:
                break;
        }
        
    }else{
        
        cell.textField.hidden =  YES;
        [cell.subscrible addTarget:self action:@selector(subscriblePressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.subscrible.enabled =  NO;
        
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        
    }
    
    
    cell.backgroundColor = [UIColor colorWithRed:231.0f/256.0f green:240.0f/256.0f blue:247.0f/256.0f  alpha:1.0];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}



-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        
        CGFloat fontSize = 15.0f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            fontSize =  18.0f;

        
        CGRect frameTable = tableView.frame;
        frameTable.origin =  CGPointZero;
        
        UIView *view = [[[UIView alloc] initWithFrame:frameTable] autorelease];
        
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, view.frame.size.width-40, 60)];
        labelTitle.textColor = [UIColor darkGrayColor];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            labelTitle.text = @"Subcrible to get the best deals on the\nApp Store sent free to your inbox.";
        else
            labelTitle.text = @"Subcrible to get the best deals on the App Store\nsent free to your inbox.";
        
        labelTitle.font =  [UIFont systemFontOfSize:fontSize];
        labelTitle.numberOfLines = 0;
        labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        labelTitle.contentMode =  UIViewContentModeTop;
        labelTitle.textAlignment =  NSTextAlignmentCenter;
        labelTitle.adjustsFontSizeToFitWidth =  YES;
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.numberOfLines = 0;
        
        [view addSubview:labelTitle];
        [labelTitle release];
        
        return view;
        
    }else{
        
        
        
        
    }
    
    return nil;
    
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        CGFloat fontSize = 15.0f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            fontSize =  18.0f;
        
        CGRect frameTable = tableView.frame;
        frameTable.origin =  CGPointZero;
        frameTable.size =  CGSizeMake(frameTable.size.width, 60);
        
        UIView *view = [[[UIView alloc] initWithFrame:frameTable] autorelease];
        view.backgroundColor = [UIColor clearColor];
              
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary = [defaults valueForKey:@"newsletter_data"];
        
        CGRect rect =  CGRectMake(20, 0, view.frame.size.width-40, 60);
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:rect];
        labelTitle.textColor = [UIColor darkGrayColor];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            labelTitle.text = (dictionary)? @"Thanks for your appreciation and trust. We'll get back\nsoon with awesome news!":@"Don't worry, I hate spam as much as you do!";
            rect =  CGRectMake(20, -15, view.frame.size.width-40, 60);
            [labelTitle setFrame:rect];
        }
        else{
             labelTitle.text = (dictionary)? @"Thanks for your appreciation and trust.\nWe'll get back soon with awesome news!":@"Don't worry, I hate spam as much as you do!";
            [self setUILabelTextWithVerticalAlignTop:labelTitle.text  withCGRect:labelTitle.frame withLabel:labelTitle];
            
            rect =  CGRectMake(20, -15, view.frame.size.width-40, 60);
            [labelTitle setFrame:rect];
        }
        
        if (dictionary)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                rect =  CGRectMake(20, -5, view.frame.size.width-40, 60);
            
                [labelTitle setFrame:rect];
            }
            
        }
        
        labelTitle.font =  [UIFont systemFontOfSize:fontSize];
        labelTitle.numberOfLines = 0;
        labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        labelTitle.contentMode =  UIViewContentModeTop;
        labelTitle.textAlignment =  NSTextAlignmentCenter;
        labelTitle.adjustsFontSizeToFitWidth =  YES;
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.numberOfLines = 0;
        
        [view addSubview:labelTitle];
        [labelTitle release];
        
        return view;

    }
    
    
    return nil;
}



- (void)setUILabelTextWithVerticalAlignTop:(NSString *)theText withCGRect:(CGRect) frame withLabel:(UILabel *) targetLabel{
    
    CGSize labelSize = CGSizeMake(frame.size.width, MAXFLOAT);
    
    CGSize theStringSize = [theText sizeWithFont:targetLabel.font constrainedToSize:labelSize lineBreakMode:targetLabel.lineBreakMode];
    
    CGRect rectLabelTitle = CGRectMake(targetLabel.frame.origin.x, targetLabel.frame.origin.y, frame.size.width, theStringSize.height);
    targetLabel.frame = rectLabelTitle;
}




-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 80;
            break;
            
        default:
            break;
    }
    
    return 0;
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return 60;
            
        default:
            break;
    }
    
    return 0;
    
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    NewsLetterCell *cell1  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath];
    NewsLetterCell *cell2  = (NewsLetterCell *)[self.nlTableView cellForRowAtIndexPath:indexPath2];

    [cell1.textField resignFirstResponder];
    [cell2.textField resignFirstResponder];
    

}


#pragma mark - Add title


-(void) addTitle
{
    //--uiimage background
    UIImage *image = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?[UIImage imageNamed:@"SettingBar_no.png"]: [UIImage imageNamed:@"SettingBar-iPad_no.png"];
    
    UIImageView *backgroundviewNavigation = [[UIImageView alloc] initWithImage:image];
    CGRect frameNavigation = CGRectZero;
    frameNavigation.origin = CGPointZero;
    frameNavigation.size =  image.size;
    
    
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-70 , 12.0f, 140, 21.0f)];
    
    titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    titleLabel.layer.shadowRadius = 1.0;
    titleLabel.layer.shadowOpacity = 1.0;
    titleLabel.layer.masksToBounds = NO;
    
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText: @"Stay Informed"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [backgroundviewNavigation addSubview:titleLabel];
    [titleLabel release];
    [self.view addSubview:backgroundviewNavigation];
    
    
    //--button black
    UIButton *buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [buttonBlack setImage:[UIImage imageNamed:@"navbar_icon_back.png"] forState:UIControlStateNormal];
        buttonBlack.frame = CGRectMake(0, 0, 46, 44);
        buttonBlack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        
        [buttonBlack setImage:[UIImage imageNamed:@"navbar_icon_back.png"] forState:UIControlStateNormal];
        buttonBlack.frame = CGRectMake(0, 0, 46, 44);
        buttonBlack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [buttonBlack addTarget:self action:@selector(buttonBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBlack];
    
    
    //--add indicator
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.hidesWhenStopped =  YES;
    
    [self.view addSubview:self.activityIndicatorView];
    
    self.activityIndicatorView.frame = CGRectMake(self.view.frame.size.width - self.activityIndicatorView.frame.size.width - 10, (44 - self.activityIndicatorView.frame.size.height)/2, self.activityIndicatorView.frame.size.width, self.activityIndicatorView.frame.size.height);

    
}


-(void)buttonBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark  - Add view background

-(void) initBackgroundImage
{
    CGRect rectFrame = self.view.frame;
    rectFrame.origin.y = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectFrame];
    if (self.imageBg)
    {
        imageView.image =  self.imageBg;
    }else{
        imageView.backgroundColor = [UIColor colorWithRed:244.0f/256.0f green:250.0f/256.0f blue:254.0f/256.0f alpha:1.0];
    }
    
    [self.view addSubview:imageView];
    
    [imageView release];
}






#pragma mark - View Did Load


-(void) loadView
{
    if (self.nibBundle != nil){
        [super loadView];
    }else{
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
        CGRect screenBoundsHasNavigatationBar = CGRectMake(0, 0, applicationFrame.size.width, applicationFrame.size.height - 44);
        
        CGRect frame = self.wantsFullScreenLayout? screenBounds:screenBoundsHasNavigatationBar;
        self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
        self.view.autoresizesSubviews =  YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        
        
    }
    
    [self initBackgroundImage];
    
    [self initTableView];
    [self addTitle];
    
    
}


/** Register notification center for view controller */
-(void) registerNotification
{
    
}


/** Set data when view did load.
 ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
-(void) setDataWhenViewDidLoad
{
    
    
}


/** Set view when view did load
 ** Be there. You can change the layout, view, button,..*/
-(void) setViewWhenViewDidLoad
{
    
}

- (void)viewDidLoad
{
    [self registerNotification];
    [self setDataWhenViewDidLoad];
    [self setViewWhenViewDidLoad];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) dealloc
{
    [_activityIndicatorView release];
    [_email release];
    [_imageBg release];
    [_nlTableView release];
    
    [super dealloc];
}

@end
