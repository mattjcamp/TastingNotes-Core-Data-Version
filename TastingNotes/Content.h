//
//  Content.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group_Template, Note;

@interface Content : NSManagedObject

@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) Note *belongsToNote;
@property (nonatomic, retain) Group_Template *inThisGroup;

@end
