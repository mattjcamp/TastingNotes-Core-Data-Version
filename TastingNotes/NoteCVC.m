//
//  NoteCVC.m
//  TastingNotes
//
//  Created by Matt on 1/29/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NoteCVC.h"
#import "CCVC.h"
#import "ViewFactory.h"

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
    
    //Add First View
    cvc.myScrollView.pagingEnabled = YES;
    CGFloat totalHeight = 0;
    CGFloat y = cvc.frame.origin.y;
    CGRect r = CGRectMake(cvc.frame.origin.x,
                          y,
                          cvc.frame.size.width,
                          cvc.frame.size.height);
    UIView *v = [ViewFactory testViewWithThisReferenceFrame:r];
    totalHeight = totalHeight + v.frame.size.height;
    [cvc.myScrollView addSubview:v];
    
    //Add Second View
    for(int i = 0;i<80;i++){
        y = y + v.frame.size.height + 5;
        r = CGRectMake(cvc.frame.origin.x,
                       y,
                       cvc.frame.size.width,
                       v.frame.size.height);
        v = [ViewFactory testViewWithThisReferenceFrame:r];
        totalHeight = totalHeight + v.frame.size.height;
        [cvc.myScrollView addSubview:v];
    }
    
    cvc.myScrollView.contentSize = CGSizeMake(cvc.contentView.frame.size.width, totalHeight);
    
    return cvc;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end