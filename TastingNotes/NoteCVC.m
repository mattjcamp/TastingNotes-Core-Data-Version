//
//  NoteCVC.m
//  TastingNotes
//
//  Created by Matt on 1/29/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NoteCVC.h"
#import "CCVC.h"

@interface NoteCVC ()

@end

@implementation NoteCVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.note.title;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.note.belongsToNotebook groups].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder] objectAtIndex:indexPath.row];
    
    CCVC *cvc = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVCCell"
                                                          forIndexPath:indexPath];
    
    cvc.myLabel.text = gt.name;
    
    NSMutableString *contentString = [[NSMutableString alloc]init];
    
    [gt.contentTypesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [contentString appendFormat:@"%@\n", [self.note contentInThisGroup:gt
                                                        andThisContentType:obj]];
    }];
    
    cvc.myTextView.text = contentString;
    
    return cvc;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        //headerView.title.text = title;
        
        reusableview.backgroundColor = [UIColor yellowColor];
        
        reusableview = headerView;
    }
    
    return reusableview;
    
    
}

@end