//
//  HomeViewController.m
//  NSThread-GCD-NSOperation
//
//  Created by ios2chen on 2018/8/23.
//  Copyright © 2018年 Lfy. All rights reserved.
//

#import "HomeViewController.h"
#import "QRCodeScanController.h"


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *iNavigationView;

@end

@implementation HomeViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.navigationController pushViewController:[[QRCodeScanController alloc] init]animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.iNavigationView.frame = CGRectMake(0, 0, UIScreen_Width, UIScreen_StatusHeight+44);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
