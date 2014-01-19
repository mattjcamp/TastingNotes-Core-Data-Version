//
//  SelectedListObject.h
//  TastingNotes
//
//  Created by Matt on 1/19/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content;

@interface SelectedListObject : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) Content *belongsToContent;

@end
