//
//  Notebook.h
//  TastingNotes
//
//  Created by Matt on 1/7/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Notebook_Template;

@interface Notebook : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) Notebook_Template *template;
@property (strong) NSNumber *pk;

@end

@interface Notebook (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
