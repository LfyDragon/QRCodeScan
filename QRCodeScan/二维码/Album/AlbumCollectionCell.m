//
//  AlbumCollectionCell.m
//  dock
//
//  Created by ios2chen on 2018/10/11.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import "AlbumCollectionCell.h"


@interface AlbumCollectionCell ()
@property (strong, nonatomic) IBOutlet UIImageView *iImageView;
@property (strong, nonatomic) IBOutlet UILabel *iLabel;

@end

@implementation AlbumCollectionCell


-(void)configCellData:(CollectionModel *)model{
    
    self.iImageView.image = model.image;
    self.iLabel.text = [NSString stringWithFormat:@"%@(%@)",model.title,[NSNumber numberWithInteger:model.count]];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
