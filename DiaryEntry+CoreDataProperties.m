//
//  DiaryEntry+CoreDataProperties.m
//  Diary
//
//  Created by Shan Rammah on 2/1/16.
//  Copyright © 2016 Shan Rammah. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DiaryEntry+CoreDataProperties.h"

@implementation DiaryEntry (CoreDataProperties)

@dynamic date;
@dynamic body;
@dynamic imageData;
@dynamic mood;
@dynamic location;

@end
