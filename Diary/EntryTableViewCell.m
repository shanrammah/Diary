//
//  EntryTableViewCell.m
//  Diary
//
//  Created by Shan Rammah on 2/3/16.
//  Copyright © 2016 Shan Rammah. All rights reserved.
//

#import "EntryTableViewCell.h"
#import "DiaryEntry.h"
#import <QuartzCore/QuartzCore.h>

@interface EntryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation EntryTableViewCell

+ (CGFloat)heightForEntry:(DiaryEntry *)entry
{
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 160.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(275, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                               attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}

- (void)configureCellForEntry:(DiaryEntry *)entry
{
    
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    
    if (entry.imageData) {
        self.mainImageView.image = [UIImage imageWithData:entry.imageData];
    } else {
        //if there is no image data
        self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
    }
    
    if (entry.mood == DiaryEntryMoodGood) {
        
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
        
    } else if (entry.mood == DiaryEntryMoodAverage) {
        
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
        
    } else if (entry.mood == DiaryEntryMoodBad) {
        
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
        
    }
 
    self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame) / 2.0f;
    
    if (entry.location.length > 0) {
        self.locationLabel.text = entry.location;
    } else {
        self.locationLabel.text =@"No Location";
    }
}






@end
