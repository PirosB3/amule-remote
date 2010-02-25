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
@synthesize hostAddress;
@synthesize socketDelimiter;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
	hostAddress= [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddressPref"];
	NSLog(hostAddress);
	socket= [[AsyncSocket alloc] initWithDelegate:self];
	NSError *error;
	//Added dummy port
	if(![socket connectToHost:hostAddress onPort:14000 error:&error]){
		NSLog(@"error: %@", error);
	}
	else{
		self.socketDelimiter= [@"</root>" dataUsingEncoding:NSASCIIStringEncoding];
		[socket readDataToData:self.socketDelimiter withTimeout:-1 tag:2];
	}
}

-(void)XMLParse:(NSData *)data{
//
//	NSString *aString= [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//	NSLog(@"Data is:\n**********%@**********\n", aString);
//
	[parser release];
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
	UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Connection failed" message:@"There has been connection problem, or you haven't configured your host in the Settings Pane" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag{
	[self XMLParse:data];
	[socket readDataToData:self.socketDelimiter withTimeout:-1 tag:2];
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
// - (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
//  NSLog(@"Error: %@ %@ %@", parseError, [parseError userInfo], [parseError description]);
// }

// END DELEGATES XML PARSER
- (void)dealloc {
	[xmlArray release];
	[socket release];
	[socketDelimiter release];
	[parser release];
    [tabBarController release];
	[hostAddress release];
    [window release];
    [super dealloc];
}
@end

