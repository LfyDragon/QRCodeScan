//
//  AlbumPhotoController.h
//  dock
//
//  Created by ios2chen on 2018/10/11.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureChooseProtocol <NSObject>
-(void)choosePictureArray:(NSArray *)array;
@end

@interface AlbumPhotoController : UIViewController
-(id)initWithCollection:(PHAssetCollection *)collection;
@property (weak, nonatomic) id<PictureChooseProtocol> delegate;
@end
