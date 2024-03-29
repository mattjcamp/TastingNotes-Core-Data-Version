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

-(void)removeAllContent{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    [[self notebooks] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [context deleteObject:obj];
    }];
    
    [self save];
    
    [[self notebooks] removeAllObjects];
    
}

static AppContent *singletonInstance = nil;

+ (AppContent *)sharedContent{
    @synchronized(self){
        if (singletonInstance == nil)
            singletonInstance = [[self alloc] init];
        
        return(singletonInstance);
    }
}

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

-(Content *)addNewContentToThisNote:(Note *)note
                inThisGroupTemplate:(Group_Template *)gt
                 andThisContentType:(ContentType_Template *)ct{
    NSManagedObjectContext *context = [self managedObjectContext];
    Content *content = [NSEntityDescription insertNewObjectForEntityForName:@"Content"
                                                     inManagedObjectContext:context];
    content.belongsToNote = note;
    content.inThisGroup = gt;
    content.inThisContent_Type = ct;
    
    return content;
}

-(NSNumber *)maxNotebookOrder{
    NSNumber *max = [self.notebooks valueForKeyPath:@"@max.order"];
    
    return max;
}

-(Notebook *)addNewNotebookWithThisName:(NSString *)name{
    if(!_notebooks)
        [self.notebooks count];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    Notebook *notebook = [NSEntityDescription insertNewObjectForEntityForName:@"Notebook"
                                                       inManagedObjectContext:context];
    notebook.name = name;
    notebook.order = [NSNumber numberWithInt:[[self maxNotebookOrder] integerValue] + 1];
    [self.notebooks addObject:notebook];
    
    return notebook;
}

-(Group_Template *) addGroupTemplateWithThisName:(NSString *)name
                                  toThisNotebook:(Notebook *)n{
    NSManagedObjectContext *context = [self managedObjectContext];
    Group_Template *gt =[NSEntityDescription insertNewObjectForEntityForName:@"Group_Template"
                                                      inManagedObjectContext:context];
    gt.name = name;
    gt.order = [NSNumber numberWithInt:[[n maxGroupOrder] integerValue] + 1];
    [n addGroupsObject:gt];
    
    return gt;
}

-(ContentType_Template *)addContentTypeTemplateWithThisName:(NSString *)name
                                        toThisGroupTemplate:(Group_Template *)gt{
    NSManagedObjectContext *context = [self managedObjectContext];
    ContentType_Template *template =[NSEntityDescription insertNewObjectForEntityForName:@"ContentType_Template"
                                                                  inManagedObjectContext:context];
    template.name = name;
    template.order = [NSNumber numberWithInt:[[gt maxContentTypeOrder] integerValue] + 1];
    template.type = @"SmallText";
    [gt addContentTypesObject:template];
    
    return template;
}

-(ListObject *)addListObjectWithThisName:(NSString *)name
                       toThisContentType:(ContentType_Template *)ct{
    NSManagedObjectContext *context = [self managedObjectContext];
    ListObject *listObject =[NSEntityDescription insertNewObjectForEntityForName:@"ListObject"
                                                          inManagedObjectContext:context];
    listObject.name = name;
    NSNumber *num = [NSNumber numberWithInt:[[ct maxListObjectOrder] integerValue] + 1];
    listObject.order = num;
    listObject.identifier = num;
    
    [ct addListObjectsObject:listObject];
    
    return listObject;
}

-(SelectedListObject *)addSelectedListObjectWithThisIdentifier:(NSNumber *)identifier
                                                 toThisContent:(Content *) c{
    NSManagedObjectContext *context = [self managedObjectContext];
    SelectedListObject *selectedListObject =[NSEntityDescription insertNewObjectForEntityForName:@"SelectedListObject"
                                                                          inManagedObjectContext:context];
    
    selectedListObject.identifier = identifier;
    [c addSelectedListObjectsObject:selectedListObject];
    
    return selectedListObject;
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
    
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"order"
                                                         ascending:YES];
    request.sortDescriptors = @[sd];
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

AppState *_appState;
-(AppState *)appState{
    if(_appState)
        return _appState;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AppState"
                                              inManagedObjectContext:context];
    request.entity = entity;
    NSError *error = nil;
    NSArray *list = [context executeFetchRequest:request
                                           error:&error];
    if(error){
        NSLog(@"Problem executing app state fetch request: %@", error);
        return nil;
    }
    
    if(list.count == 0)
        _appState =[NSEntityDescription insertNewObjectForEntityForName:@"AppState"
                                                 inManagedObjectContext:context];
    else
        _appState = [list firstObject];
    
    return _appState;
    
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