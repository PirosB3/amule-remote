// iMule
// DownloadsController.h

// RELEASED UNDER MIT LICENSE BY PirosB3
//

#import <UIKit/UIKit.h>
#import "iMuleAppDelegate.h"

@interface DownloadsController : UITableViewController {
	NSMutableArray *downloads;
	iMuleAppDelegate *delegate;
	NSData *downloadRequest;
}
- (void)parseNewDownloads:(NSMutableArray *)array;
@property(nonatomic, retain) NSData *downloadRequest;
@property(nonatomic,retain) NSMutableArray *downloads;
@property(nonatomic,retain) iMuleAppDelegate *delegate;
@end
