// iMule
// ResultsController.h

// RELEASED UNDER MIT LICENSE BY PirosB3
//

#import <UIKit/UIKit.h>
#import "iMuleAppDelegate.h"
#import "ResultsControllerCell.h"

@interface ResultsController : UITableViewController <UISearchBarDelegate> {
	UISearchBar *searchBar;
	iMuleAppDelegate *delegate;
	NSMutableArray *results;
	NSData *resultRequest;
	UINavigationBar *navigationBar;
	UINavigationItem *navigationItem;
	UITableView *tableView;
	UIActivityIndicatorView *activity;
}
-(void)reloadTable;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property(nonatomic, retain) NSData *resultRequest;
@property(nonatomic, retain) NSMutableArray *results;
@property(nonatomic, retain) iMuleAppDelegate *delegate;
@property(nonatomic, retain) IBOutlet UISearchBar *searchBar;
@end
