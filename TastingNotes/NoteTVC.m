//
//  NoteTVC.m
//  TastingNotes
//
//  Created by Matt on 3/10/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NoteTVC.h"
#import "ViewFactory.h"

@implementation NoteTVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.note.title;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.note.belongsToNotebook groups].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder]objectAtIndex:section];
    
    return gt.name;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder]objectAtIndex:indexPath.section];
    Content *c = [[self.note contentInThisGroup:gt] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = c.stringData;
    
    return cell;
}

@end
