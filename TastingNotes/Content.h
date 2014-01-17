//
//  Content.h
//  TastingNotes
//
//  Created by Matt on 1/17/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentType_Template, Group_Template, Note;

@interface Content : NSManagedObject

@property (nonatomic, retain) NSString * stringData;
@property (nonatomic, retain) NSNumber * numberData;
@property (nonatomic, retain) NSData * binaryData;
@property (nonatomic, retain) Note *belongsToNote;
@property (nonatomic, retain) ContentType_Template *inThisContent_Type;
@property (nonatomic, retain) Group_Template *inThisGroup;

@end
