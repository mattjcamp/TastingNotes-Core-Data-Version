//
//  Group_Template.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentType_Template, Notebook_Template;

@interface Group_Template : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *contentTypes;
@property (nonatomic, retain) Notebook_Template *belongsToNotebook;
@end

@interface Group_Template (CoreDataGeneratedAccessors)

- (void)addContentTypesObject:(ContentType_Template *)value;
- (void)removeContentTypesObject:(ContentType_Template *)value;
- (void)addContentTypes:(NSSet *)values;
- (void)removeContentTypes:(NSSet *)values;

@end
