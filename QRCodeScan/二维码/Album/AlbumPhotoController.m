//
//  AlbumPhotoController.m
//  dock
//
//  Created by ios2chen on 2018/10/11.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import "AlbumPhotoController.h"
#import "QRCodeScanController.h"
#import "CustomeAlbumController.h"
#import "AlbumPhotoCell.h"


#define ItemWidth (UIScreen_Width-50)/4

@interface AlbumPhotoController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIView *iNavigationView;
@property (nonatomic, strong) PHAssetCollection *iCollection;
@property (strong, nonatomic) IBOutlet UILabel *iTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *iBackButton;
@property (strong, nonatomic) IBOutlet UICollectionView *iCollectionView;
@property (strong, nonatomic) IBOutlet UIView *iBottomView;
@property (strong, nonatomic) IBOutlet UIButton *iBottomDoneButton;
@property (strong, nonatomic) NSMutableArray *iPhtotoArray;
@property (strong, nonatomic) PHCachingImageManager *iCacheManager;
@property (strong, nonatomic) PHImageRequestOptions *iRequestOptions;

@property (strong, nonatomic) NSMutableArray *iSelectedImageArray;
@end

@implementation AlbumPhotoController


-(id)initWithCollection:(PHAssetCollection *)collection{
    if (self = [super init]) {
        self.iCollection = collection;
    }
    return self;
}

-(NSMutableArray *)iPhtotoArray{
    
    if (!_iPhtotoArray) {
        _iPhtotoArray = [NSMutableArray array];
    }
    return _iPhtotoArray;
}
-(NSMutableArray*)iSelectedImageArray{
    if (!_iSelectedImageArray) {
        _iSelectedImageArray = [NSMutableArray array];
    }
    return _iSelectedImageArray;
}
-(PHCachingImageManager *)iCacheManager{
    if (!_iCacheManager) {
        _iCacheManager = [[PHCachingImageManager alloc]init];
    }
    return _iCacheManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [self getImage];
}

-(void)configUI{
    
    self.iNavigationView.frame = CGRectMake(0, 0, UIScreen_Width, UIScreen_StatusHeight+44);
    
    self.iCollectionView.frame = CGRectMake(0, UIScreen_StatusHeight+44, UIScreen_Width, UIScreen_Height-UIScreen_StatusHeight-44);
    
    CustomeAlbumController *vc = [[CustomeAlbumController alloc]init];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [array insertObject:vc atIndex:array.count-1];
    self.navigationController.viewControllers = array;
    
    [self.iCollectionView registerNib:[UINib nibWithNibName:@"AlbumPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoItemCell"];
    
}

-(void)getImage{
    
    self.iRequestOptions = [[PHImageRequestOptions alloc]init];
    self.iRequestOptions.synchronous = YES;
    self.iRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    self.iRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    //只筛选有照片的相册
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    
    if (!self.iCollection) {
        //无数据
        
        if ([DevelopmentUtil albumAuthorization]) {
            //有权限
            NSMutableArray *array = [NSMutableArray array];
            //获取所有的相册
            PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            for (PHAssetCollection *collection in assetCollections) {
                
                [array addObject:collection];
                
            }
            
            for (PHAssetCollection *collection in array) {
                //获取每个相册内的所有照片
                PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
                
                NSLog(@"相册名=%@,照片数量=%@",collection.localizedTitle,[NSNumber numberWithInteger:assets.count]);
                if (assets.count>0 && [array indexOfObject:collection]==0) {
                    self.iCollection = collection;
                    for (PHAsset *asset in assets) {
                        [self.iPhtotoArray addObject:asset];
                    }
                }
                
                if (assets.count>0 && [collection.localizedTitle isEqualToString:@"相机胶卷"]) {
                    //Camera Roll,一般情况下，照片是默认存放在相机胶圈这个相册内，所以默认情况下直接打开‘相机胶卷’，在这里，因为我添加了中文语言，相册名是‘相机胶圈’，否则就是‘Camera Roll’，这个要注意。
                    
                    self.iCollection = collection;
                    if (self.iPhtotoArray.count>0) {
                        [self.iPhtotoArray removeAllObjects];
                    }
                    for (PHAsset *asset in assets) {
                        [self.iPhtotoArray addObject:asset];
                    }
                    break;
                    
                }
                
            }
        } else {
            //无权限
            self.iCollectionView.hidden = self.iBackButton.hidden = YES;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:@"请在iPhone的“设置-隐私-照片”选项中允许该APP访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:sureAction];
            return;
        }
        
    } else {
        //已有相册数据，不用再检查权限
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:self.iCollection options:fetchOptions];
        if (self.iPhtotoArray.count>0) {
            [self.iPhtotoArray removeAllObjects];
        }
        for (PHAsset *asset in assets) {
            [self.iPhtotoArray addObject:asset];
        }
    }
    
    [self.iCacheManager startCachingImagesForAssets:self.iPhtotoArray targetSize:CGSizeMake(ItemWidth, ItemWidth) contentMode:PHImageContentModeAspectFill options:self.iRequestOptions];
    
    self.iTitleLabel.text = self.iCollection.localizedTitle;
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:self.iPhtotoArray.count-1 inSection:0];
    [self.iCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    [self.iCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.iPhtotoArray.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    PHAsset *asset = self.iPhtotoArray[indexPath.row];
    
    static NSString *identify = @"PhotoItemCell";
    AlbumPhotoCell *cell = (AlbumPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [self.iCacheManager requestImageForAsset:asset targetSize:CGSizeMake(ItemWidth, ItemWidth) contentMode:PHImageContentModeAspectFill options:self.iRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.iImageView.image = result;
    }];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PHAsset *asset = self.iPhtotoArray[indexPath.row];
    
    [self.iCacheManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:self.iRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        NSArray *array = self.navigationController.viewControllers;
        for (UIViewController *vc in array) {
            if ([vc isKindOfClass:[QRCodeScanController class]]) {
                QRCodeScanController *homeVC = (QRCodeScanController *)vc;
                [self.navigationController popToViewController:homeVC animated:NO];
            }
        }
        
        [self.delegate choosePictureArray:[NSArray arrayWithObjects:result, nil]];
        
    }];
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ItemWidth, ItemWidth);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}



#pragma mark - Action
- (IBAction)backButtonAction:(id)sender {
    
    NSArray *array = self.navigationController.viewControllers;
    for (UIViewController *vc in array) {
        if ([vc isKindOfClass:[CustomeAlbumController class]]) {
            CustomeAlbumController *albumVC = (CustomeAlbumController *)vc;
            [self.navigationController popToViewController:albumVC animated:YES];
        }
    }
}
- (IBAction)cancelAction:(id)sender {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    NSArray *array = self.navigationController.viewControllers;
    for (UIViewController *vc in array) {
        if ([vc isKindOfClass:[QRCodeScanController class]]) {
            QRCodeScanController *homeVC = (QRCodeScanController *)vc;
            [self.navigationController popToViewController:homeVC animated:NO];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
