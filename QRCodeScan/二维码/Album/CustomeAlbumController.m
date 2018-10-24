//
//  CustomeAlbumController.m
//  dock
//
//  Created by ios2chen on 2018/10/10.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import "CustomeAlbumController.h"
#import "QRCodeScanController.h"
#import "AlbumPhotoController.h"
#import "AlbumCollectionCell.h"

@interface CustomeAlbumController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *iNavigationView;
@property (strong, nonatomic) IBOutlet UITableView *iTableView;
@property (strong, nonatomic) NSMutableArray *iCollectionArray;
@end

@implementation CollectionModel

@end

@implementation CustomeAlbumController

-(NSMutableArray *)iCollectionArray{
    
    if (!_iCollectionArray) {
        _iCollectionArray = [NSMutableArray array];
    }
    return _iCollectionArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.iNavigationView.frame = CGRectMake(0, 0, UIScreen_Width, UIScreen_StatusHeight+44);
    self.iTableView.frame = CGRectMake(0, UIScreen_StatusHeight+44, UIScreen_Width, UIScreen_Height-UIScreen_StatusHeight-44-BottomHeight);
    self.iTableView.tableFooterView= [UIView new];
    [self getAlbum];
}

-(void)getAlbum{
    
    if ([DevelopmentUtil albumAuthorization]) {
        PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *userCollections = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
        [self configDataCollection:assetCollections];
        [self configDataCollection:userCollections];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.iTableView reloadData];
        });
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:@"请在iPhone的“设置-隐私-照片”选项中允许该APP访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:sureAction];
    
    }
    
    
    
}

-(void)configDataCollection:(PHFetchResult *)result{
    
    for (PHAssetCollection *collection in result) {
        
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
        
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
        
        if (assets.count>0) {
            CollectionModel *model = [[CollectionModel alloc]init];
            model.assetCollection = collection;
            model.title = collection.localizedTitle;
            model.count = assets.count;
            
            PHImageRequestOptions *requestOption = [[PHImageRequestOptions alloc]init];
            requestOption.synchronous = YES;
            requestOption.resizeMode = PHImageRequestOptionsResizeModeExact;
            requestOption.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            
            [[PHCachingImageManager defaultManager] requestImageForAsset:[assets firstObject] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:requestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                model.image = result;
            }];
            
            [self.iCollectionArray addObject:model];
        }
        
    }
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.iCollectionArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"AlbumCollectionCell";
    
    CollectionModel *model = self.iCollectionArray[indexPath.row];
    
    AlbumCollectionCell *cell = (AlbumCollectionCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identify owner:self options:nil]lastObject];
    }
    [cell configCellData:model];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionModel *model = self.iCollectionArray[indexPath.row];
    AlbumPhotoController *photoVC = [[AlbumPhotoController alloc]initWithCollection:model.assetCollection];
   
    [self.navigationController pushViewController:photoVC animated:YES];
    
}


- (IBAction)backAction:(id)sender {
    
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
