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

-(Note *)addNoteToThisNotebook:(Notebook *)notebook{
    NSManagedObjectContext *context = [self managedObjectContext];
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                               inManagedObjectContext:context];
    note.order = [NSNumber numberWithInt:[[notebook maxNoteOrder] integerValue] + 1];
    [notebook addNotesObject:note];
    
    return note;
}

-(Content *)newContent{
    NSManagedObjectContext *context = [self managedObjectContext];
    Content *content = [NSEntityDescription insertNewObjectForEntityForName:@"Content"
                                               inManagedObjectContext:context];
    
    return content;
}

-(NSNumber *)maxNotebookOrder{
    NSNumber *max = [self.notebooks valueForKeyPath:@"@max.order"];
    
    return max;
}

-(Notebook *)newNotebookWithThisName:(NSString *)name{
    NSManagedObjectContext *context = [self managedObjectContext];
    Notebook *notebook = [NSEntityDescription insertNewObjectForEntityForName:@"Notebook"
                                                    inManagedObjectContext:context];
    notebook.name = name;
    notebook.order = [NSNumber numberWithInt:[[self maxNotebookOrder] integerValue] + 1];
    
    return notebook;
}

-(Notebook_Template *)newNotebookTemplateWithThisName:(NSString *)name{
    NSManagedObjectContext *context = [self managedObjectContext];
    Notebook_Template *template =[NSEntityDescription insertNewObjectForEntityForName:@"Notebook_Template"
                                                     inManagedObjectContext:context];
    template.name = name;
    
    return template;
}

-(Group_Template *)newGroupTemplateWithThisName:(NSString *)name{
    NSManagedObjectContext *context = [self managedObjectContext];
    Group_Template *template =[NSEntityDescription insertNewObjectForEntityForName:@"Group_Template"
                                                               inManagedObjectContext:context];
    template.name = name;
    
    return template;
}

-(ContentType_Template *)newContentType_TemplateWithThisName:(NSString *)name{
    NSManagedObjectContext *context = [self managedObjectContext];
    ContentType_Template *template =[NSEntityDescription insertNewObjectForEntityForName:@"ContentType_Template"
                                                            inManagedObjectContext:context];
    template.name = name;
    
    return template;
}

-(Notebook *)newWineNotebook{
    Notebook *notebook = [self newNotebookWithThisName:@"Wine Notes"];
    notebook.template = [self newNotebookTemplateWithThisName:@"Wine Notebook Template"];
    
    Group_Template *g = [self newGroupTemplateWithThisName:@"Overview"];
    g.order = @0;
    ContentType_Template *c = [self newContentType_TemplateWithThisName:@"Wine Name"];
    c.order = @0;
    c.type = @"smalltext";
    [g addContentTypesObject:c];
    c = [self newContentType_TemplateWithThisName:@"Wine Type"];
    c.name = @"Wine Type";
    c.order = @1;
    c.type = @"list";
    [g addContentTypesObject:c];
    [notebook.template addGroupsObject:g];
    
    g = [self newGroupTemplateWithThisName:@"Description"];
    g.order = @1;
    [notebook.template addGroupsObject:g];
    
    g = [self newGroupTemplateWithThisName:@"Ratings"];
    g.order = @2;
    [notebook.template addGroupsObject:g];
    
    return notebook;
}

-(void)addThisNotebookToList:(Notebook *)notebook{
    [self.notebooks addObject:notebook];
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
    
    _notebooks = [[NSMutableArray alloc]initWithArray:listOfNotebooks];
    
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