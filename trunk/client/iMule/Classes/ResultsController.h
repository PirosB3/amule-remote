//
//  ResultsController.h
//  iMule
//
//  Created by piros on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iMuleAppDelegate.h"

@interface ResultsController : UITableViewController <UISearchBarDelegate> {
	UISearchBar *searchBar;
	iMuleAppDelegate *delegate;
	NSMutableArray *results;
	NSData *resultRequest;
}
@property(nonatomic, retain) NSData *resultRequest;
@property(nonatomic, retain) NSMutableArray *results;
@property(nonatomic, retain) iMuleAppDelegate *delegate;
@property(nonatomic, retain) IBOutlet UISearchBar *searchBar;
@end
