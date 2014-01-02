//
//  TableViewCommon.m
//  RingTones
//
//  Created by VinhTran on 12/16/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "TableViewCommon.h"
#import "PopularCell.h"


@interface TableViewCommon ()

@end

@implementation TableViewCommon

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/********************************************************************************/
#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"PopularCell";
    
    PopularCell *cell = (PopularCell *)[self.tableListRingtones dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil)
    {
        
        NSArray *nibObjects = nil;
        //--load cell for Ipad--//
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            nibObjects = [[NSBundle mainBundle] loadNibNamed:@"IpadPopularCell" owner: nil options:nil];
            
            for(id currentObject in nibObjects){
                if([currentObject isKindOfClass:[PopularCell class]]){
                    cell = (PopularCell *) currentObject;
                    break;
                }
            }
            
        }
        else
        {
            nibObjects = [[NSBundle mainBundle] loadNibNamed:@"PopularCell" owner: nil options:nil];
            
            for(id currentObject in nibObjects){
                if([currentObject isKindOfClass:[PopularCell class]]){
                    cell = (PopularCell *) currentObject;
                    break;
                }
            }
            
        }
        for (id currentObject in nibObjects)
        {
            if ([currentObject isKindOfClass:[PopularCell class]])
            {
                cell = (PopularCell *) currentObject;
                
            }
        }
    }
    
    
    cell = [self setDataForCell:cell withIndexPath:indexPath];
    
    return cell;
}


-(PopularCell *) setDataForCell:(PopularCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    return cell;
}



/********************************************************************************/


/********************************************************************************/
#pragma mark UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


/********************************************************************************/



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
