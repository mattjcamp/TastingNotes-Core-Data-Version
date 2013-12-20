//
//  AppContent.m
//  tastingnotes
//
//  Created by Matt on 12/19/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "AppContent.h"
#import <CoreData/CoreData.h>

@interface AppContent ()

-(NSURL *)dataStoreURL;
@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

@end

@implementation AppContent
/*
 -(void)removeThisNote:(Note *)note{
 NSManagedObjectContext *context = [self managedObjectContext];
 [context deleteObject:note];
 [self.notebook removeNotesObject:note];
 }
 
 -(Note *)addNote{
 NSManagedObjectContext *context = [self managedObjectContext];
 Note *n = (Note *)[NSEntityDescription insertNewObjectForEntityForName:@"Note"
 inManagedObjectContext:context];
 n.timeStamp = [NSDate date];
 n.content = @"ABCDefghijklmnop";
 [self.notebook addNotesObject:n];
 
 return n;
 }
 */

-(void)save{
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    if(context.hasChanges)
        [context save:&error];
    if(error){
        NSLog(@"Save failed:%@", error);
    }
}

-(Notebook *)newWineNotebook{
    NSManagedObjectContext *context = [self managedObjectContext];
    Notebook *notebook = [NSEntityDescription insertNewObjectForEntityForName:@"Notebook"
                                                       inManagedObjectContext:context];
    notebook.name = @"Wine Notes";
    notebook.order = [NSNumber numberWithInt: _notebooks.count];
    notebook.template =[NSEntityDescription insertNewObjectForEntityForName:@"Notebook_Template"
                                                     inManagedObjectContext:context];
    notebook.template.name = @"Wine Notebook Template";
    
    Group_Template *g_o = [NSEntityDescription insertNewObjectForEntityForName:@"Group_Template"
                                                      inManagedObjectContext:context];
    g_o.name = @"Overview";
    g_o.order = @0;
    
    [notebook.template addGroupsObject:g_o];
    
    Group_Template *g_d = [NSEntityDescription insertNewObjectForEntityForName:@"Group_Template"
                                                        inManagedObjectContext:context];
    g_d.name = @"Description";
    g_d.order = @1;
    
    [notebook.template addGroupsObject:g_d];
    
    return notebook;
}

NSMutableArray *_notebooks;
-(NSMutableArray *)notebooks{
    if(_notebooks)
        return _notebooks;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notebook"
                                              inManagedObjectContext:context];
    request.entity = entity;
    NSError *error = nil;
    NSArray *listOfNotebooks = [context executeFetchRequest:request
                                                      error:&error];
    if(error){
        NSLog(@"Problem executing notebooks fetch request: %@", error);
        return nil;
    }
    
    if(listOfNotebooks.count > 0){;
        _notebooks = [[NSMutableArray alloc] initWithArray:listOfNotebooks];
        return _notebooks;
    }
    
    _notebooks = [[NSMutableArray alloc]initWithObjects:[self newWineNotebook], nil];
    
    return _notebooks;
}

-(NSURL *)dataStoreURL {
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"data.sql"]];
}

NSManagedObjectModel *_objectModel;
-(NSManagedObjectModel *)managedObjectModel {
    if (_objectModel) {
        return _objectModel;
    }
    _objectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _objectModel;
}

NSPersistentStoreCoordinator *_coordinator;
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_coordinator) {
        return _coordinator;
    }
    
    NSError *error = nil;
    NSManagedObjectModel *m = [self managedObjectModel];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:m];
    if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                    configuration:nil
                                              URL:[self dataStoreURL]
                                          options:nil
                                            error:&error]) {
        NSLog(@"%@, %@", error, [error userInfo]);
    }
    
    return _coordinator;
}

NSManagedObjectContext *_context;
-(NSManagedObjectContext *)managedObjectContext {
    if (_context) {
        return _context;
    }
    
    if ([self persistentStoreCoordinator]) {
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    }
    
    return _context;
}

@end