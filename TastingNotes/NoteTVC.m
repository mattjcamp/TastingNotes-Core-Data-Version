//
//  NoteTVC.m
//  TastingNotes
//
//  Created by Matt on 3/10/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NoteTVC.h"
#import "ViewFactory.h"

@interface NoteTVC ()

@property ViewFactory *vf;

@end

@implementation NoteTVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.note.title;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.vf = [[ViewFactory alloc]initWithNote:self.note];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.note.belongsToNotebook groups].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder]objectAtIndex:section];
    
    return gt.name;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder]objectAtIndex:section];

    return [self.note contentInThisGroup:gt].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder]objectAtIndex:indexPath.section];
    ContentType_Template *ct = [[gt contentTypesByOrder] objectAtIndex:indexPath.row];
    Content *c = [self.note contentInThisGroup:gt andThisContentType:ct];
    
    [cell.contentView addSubview: [self.vf viewForThisGroupTemplate:gt
                                                     andThisContent:c]];
    
    return cell;
}

@end
