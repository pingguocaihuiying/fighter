//
//  FTBoxingBarModuleCollectionView.h
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

@protocol FTCollectionViewDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

#import <UIKit/UIKit.h>

@interface FTBoxingBarModuleCollectionView : UIView

@property (nonatomic, weak) id<FTCollectionViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
