//
//  ResultsControllerCell.h
//  iMule
//
//  Created by piros on 2/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultsControllerCell : UITableViewCell {
	UILabel *fileName;
	UILabel *fileSize;
	UILabel *fileDisp;
}
@property (nonatomic, retain) IBOutlet UILabel *fileName;
@property (nonatomic, retain) IBOutlet UILabel *fileSize;
@property (nonatomic, retain) IBOutlet UILabel *fileDisp;
@end
