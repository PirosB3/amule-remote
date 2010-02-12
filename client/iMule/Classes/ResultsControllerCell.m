//
//  ResultsControllerCell.m
//  iMule
//
//  Created by piros on 2/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResultsControllerCell.h"


@implementation ResultsControllerCell
@synthesize fileName, fileSize, fileDisp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
