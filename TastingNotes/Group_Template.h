//
//  Group_Template.h
//  TastingNotes
//
//  Created by Matt on 1/21/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, ContentType_Template, Notebook;

@interface Group_Template : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Notebook *belongsToNotebook;
@property (nonatomic, retain) NSSet *contentInThisGroup;
@property (nonatomic, retain) NSSet *contentTypes;
@end

@interface Group_Template (CoreDataGeneratedAccessors)

- (void)addContentInThisGroupObject:(Content *)value;
- (void)removeContentInThisGroupObject:(Content *)value;
- (void)addContentInThisGroup:(NSSet *)values;
- (void)removeContentInThisGroup:(NSSet *)values;

- (void)addContentTypesObject:(ContentType_Template *)value;
- (void)removeContentTypesObject:(ContentType_Template *)value;
- (void)addContentTypes:(NSSet *)values;
- (void)removeContentTypes:(NSSet *)values;

@end
