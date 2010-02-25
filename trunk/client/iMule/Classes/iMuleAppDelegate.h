// iMule
// iMuleAppDelegate.h

// RELEASED UNDER MIT LICENSE BY PirosB3
//

#import "AsyncSocket.h"
#import <UIKit/UIKit.h>

@class DownloadsController;
@class ResultsController;

@interface iMuleAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	AsyncSocket *socket;
	NSXMLParser *parser;
	NSMutableArray *xmlArray;
	DownloadsController *downloads_Controller;
	ResultsController *results_controller;
	NSString *hostAddress;
	NSData *socketDelimiter;
}
-(void)XMLParse:(NSData *)data;
@property(nonatomic, retain) NSData *socketDelimiter;
@property(nonatomic, retain) NSString *hostAddress;
@property(nonatomic, retain) IBOutlet ResultsController *results_controller;
@property(nonatomic, retain) IBOutlet DownloadsController *downloads_Controller;
@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic, retain) AsyncSocket *socket;
@property(nonatomic, retain) NSXMLParser *parser;
@property(nonatomic, retain) NSMutableArray *xmlArray;
@end
