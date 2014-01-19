//
//  ListObject.h
//  TastingNotes
//
//  Created by Matt on 1/19/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentType_Template;

@interface ListObject : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * objectDescription;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) ContentType_Template *belongsToThisContentType;

@end
