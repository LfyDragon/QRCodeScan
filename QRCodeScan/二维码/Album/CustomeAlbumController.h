//
//  CustomeAlbumController.h
//  dock
//
//  Created by ios2chen on 2018/10/10.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeAlbumController : UIViewController
@property (strong, nonatomic) UIViewController *iParentsVC;
@end

@interface CollectionModel: NSObject

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger count;

@end
