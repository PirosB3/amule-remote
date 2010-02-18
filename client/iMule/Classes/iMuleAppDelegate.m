// iMule
// iMuleAppDelegate.m

// RELEASED UNDER MIT LICENSE BY PirosB3
//

#import "iMuleAppDelegate.h"
#import "DownloadsController.h"
#import "ResultsController.h"

@implementation iMuleAppDelegate
@synthesize window;
@synthesize tabBarController;
@synthesize socket;
@synthesize parser;
@synthesize xmlArray;
@synthesize downloads_Controller;
@synthesize results_controller;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
	socket= [[AsyncSocket alloc] initWithDelegate:self];
	NSError *error;
	//Added dummy port
	if(![socket connectToHost:@"192.168.0.10" onPort:14000 error:&error]){
		NSLog(@"error: %@", error);
	}
	else{
		[socket readDataWithTimeout:-1 tag:2];
	}
}

-(void)XMLParse:(NSData *)data{
	parser= [NSXMLParser alloc];
	parser.delegate= self;
	[parser initWithData:data];
	[parser parse];
}
/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


//DELEGATES SOCKET
-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
	UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Connection failed" message:@"There was a connection problem" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag{
	//NSString *results_string= [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	//output.text= results_string;
	[self XMLParse:data];
	[socket readDataWithTimeout:-1 tag:1];
	//[results_string release];
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
	[window addSubview:tabBarController.view];
}
// END DELEGATES SOCKET

// DELEGATE XML PARSER

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if([elementName isEqualToString:@"downloads"] || [elementName isEqualToString:@"results"]){
		NSLog(@"starting or downloads or results");
		if(xmlArray){
			xmlArray= nil;
		}
		self.xmlArray= [[NSMutableArray alloc] init];
		if([elementName isEqualToString:@"results"]) {
			NSLog(@"Result");
			[self.results_controller.activity startAnimating];
		}
	}
	else if([elementName isEqualToString:@"file"]){
		NSLog(@"found file...");
		[self.xmlArray addObject:attributeDict];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	NSLog(elementName);
	if([elementName isEqualToString:@"downloads"] || [elementName isEqualToString:@"results"]){
		if([elementName isEqualToString:@"downloads"]){
			NSLog(@"downloads found...  reloading table");
			self.downloads_Controller.downloads= xmlArray;
			[self.downloads_Controller.tableView reloadData];
		}
		else if([elementName isEqualToString:@"results"]){
			NSLog(@"results found... reloading table");
			self.results_controller.results= xmlArray;
			[self.results_controller.tableView reloadData];
			[self.results_controller.activity stopAnimating];
		}
	}
	else if([elementName isEqualToString:@"error"]){
		UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error" message:@"aMule dosent seem to be on" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

// END DELEGATES XML PARSER
- (void)dealloc {
	[xmlArray release];
	[socket release];
	[parser release];
    [tabBarController release];
    [window release];
    [super dealloc];
}
@end

