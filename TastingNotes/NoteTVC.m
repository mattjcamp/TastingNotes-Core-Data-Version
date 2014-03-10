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
    //return [self.note.belongsToNotebook groups].count;
    //Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder]objectAtIndex:indexPath.row];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"row:%i", indexPath.row];
    
    return cell;
}

@end
