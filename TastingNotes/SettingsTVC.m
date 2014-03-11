//
//  SettingsTVC.m
//  TastingNotes
//
//  Created by Matt on 3/11/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "SettingsTVC.h"

@interface SettingsTVC ()

-(IBAction)doneButtonAction:(id)sender;

@end

@implementation SettingsTVC

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

-(IBAction)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

@end
