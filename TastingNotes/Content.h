//
//  Content.h
//  TastingNotes
//
//  Created by Matt on 1/7/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentType_Template, Group_Template, Note;

@interface Content : NSManagedObject

@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) Note *belongsToNote;
@property (nonatomic, retain) ContentType_Template *inThisContent_Type;
@property (nonatomic, retain) Group_Template *inThisGroup;

@end
