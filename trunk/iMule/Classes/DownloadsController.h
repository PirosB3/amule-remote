//
//  DownloadsController.h
//  iMule
//
//  Created by piros on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iMuleAppDelegate.h"

//#define delegate [[UIApplication sharedApplicaion delegate]

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
