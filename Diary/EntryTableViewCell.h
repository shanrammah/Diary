//
//  EntryTableViewCell.h
//  Diary
//
//  Created by Shan Rammah on 2/3/16.
//  Copyright © 2016 Shan Rammah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiaryEntry; 

@interface EntryTableViewCell : UITableViewCell

+ (CGFloat)heightForEntry:(DiaryEntry *)entry;

- (void)configureCellForEntry:(DiaryEntry *)entry;





@end
