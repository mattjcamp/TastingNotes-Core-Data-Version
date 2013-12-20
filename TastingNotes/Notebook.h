//
//  Notebook.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notebook_Template;

@interface Notebook : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Notebook_Template *template;

@end
