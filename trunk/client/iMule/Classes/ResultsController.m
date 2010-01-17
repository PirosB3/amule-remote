// iMule
// ResultsController.m

// RELEASED UNDER MIT LICENSE BY PirosB3
//

#import "ResultsController.h"

@implementation ResultsController
@synthesize searchBar;
@synthesize delegate;
@synthesize results;
@synthesize resultRequest;
@synthesize navigationBar;
@synthesize navigationItem;
@synthesize tableView;


- (void)viewDidLoad {
	UIBarButtonItem *reload= [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStyleBordered target:self action:@selector(reloadTable)];
	self.navigationItem.rightBarButtonItem= reload;
    [super viewDidLoad];
	NSString *resultString= @"<root type=\"request\" prompt=\"results\" />";
	self.resultRequest= [resultString dataUsingEncoding:NSASCIIStringEncoding];
	[resultString release];
	
}

-(void)reloadTable{
	NSLog(@"Reloading Table");
	[[delegate socket] writeData:self.resultRequest withTimeout:-1 tag:3];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	delegate= (iMuleAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[delegate socket] writeData:self.resultRequest withTimeout:-1 tag:1];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

//- (void)viewDidUnload {
//	Release any retained subviews of the main view.
//  e.g. self.myOutlet = nil;
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	NSLog(@"results:%@", self.results);
	NSString *search= [NSString stringWithFormat:@"<root type=\"search\" value=\"%@\" />", self.searchBar.text];
	[[delegate socket] writeData:[search dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:3];
	[self.searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
	self.searchBar.text= @"";
	return YES;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text= [[results objectAtIndex:indexPath.row] valueForKey:@"name"];
	cell.detailTextLabel.text= [[results objectAtIndex:indexPath.row] valueForKey:@"disp"];
    // Set up the cell...
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *downloadString= [[NSString alloc] initWithFormat:@"<root type=\"download\" value=\"%@\" />", [NSNumber numberWithInt:indexPath.row]];
	NSLog(downloadString);
	[[delegate socket] writeData:[downloadString dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:1];
	[downloadString release];
}


- (void)dealloc {
	[results release];
	[super dealloc];
}


@end

