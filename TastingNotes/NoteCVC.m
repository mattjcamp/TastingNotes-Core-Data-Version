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
    
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder]objectAtIndex:indexPath.row];
    
    CCVC *cvc = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVCCell"
                                                          forIndexPath:indexPath];
    
    ViewFactory *vf = [[ViewFactory alloc]initWithGroupTemplate:gt
                                                        andNote:self.note
                       forThisContainerFrame:cvc.frame];
    
    cvc.myLabel.text = gt.name;
    cvc.myScrollView.pagingEnabled = YES;
    cvc.backgroundColor = [UIColor clearColor];
    
    [gt.contentTypesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [cvc.myScrollView addSubview:[vf viewForContentType:obj]];
        
        /*ContentType_Template *ct = (ContentType_Template *)obj;
        if([ct.type isEqualToString:@"Picture"]){
            Content *c = [self.note contentInThisGroup:gt
                                    andThisContentType:ct];
            self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:c.binaryData]];
        }*/
        
    }];
    
    cvc.myScrollView.contentSize = CGSizeMake(cvc.contentView.frame.size.width, vf.totalHeight);
    
    return cvc;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end