//
//  DownloadsController.m
//  iMule
//
//  Created by piros on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownloadsController.h"


@implementation DownloadsController
@synthesize downloads;
@synthesize delegate;
@synthesize downloadRequest;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/
- (void)parseNewDownloads:(NSMutableArray *)array{
	if(downloads != NULL){
		downloads= nil;
	}
	downloads= [NSMutableArray arrayWithArray:array];
	NSLog(@"Downloads are: %@", downloads);
	[self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *downloadString= @"<root type=\"request\" prompt=\"downloads\" />";
	self.downloadRequest= [downloadString dataUsingEncoding:NSASCIIStringEncoding];
	[downloadString release];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	delegate= (iMuleAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate socket] writeData:self.downloadRequest withTimeout:-1 tag:1];
//	NSLog(@"values of downloads: %@ for a total of %@", self.downloads, [self.downloads count]);
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.downloads count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text= [[downloads objectAtIndex:indexPath.row] valueForKey:@"name"];
	cell.detailTextLabel.text= [[downloads objectAtIndex:indexPath.row] valueForKey:@"status"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *hash= [NSString stringWithFormat:[[downloads objectAtIndex:indexPath.row] valueForKey:@"hash"]];
		NSString *deleteRequest= [[NSString alloc] initWithFormat:@"<root type=\"cancel\" value=\"%@\" />", hash];
		NSLog(deleteRequest);
		[[delegate socket] writeData:[deleteRequest dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:1];
		[deleteRequest release];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[downloadRequest release];
    [super dealloc];
}


@end

