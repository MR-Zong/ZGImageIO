//
//  ViewController.m
//  ZGImageIO
//
//  Created by Zong on 17/5/24.
//  Copyright © 2017年 Zong. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIImageView *originalImgView;

@end

@implementation ViewController
{
    CGImageSourceRef _incrementallyImgSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupViews];
    
    
    // Examples //
    // 1,从头获取一定长度
    [self testLongImageFromHead];
    
    // 2,获取某一部分图片
//    [self testLongImageSeek];
}


- (void)setupViews
{
    _originalImgView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 100, 100, 100)];
    _originalImgView.backgroundColor = [UIColor redColor];
    _originalImgView.image = [UIImage imageNamed:@"sky.jpg"];
    [self.view addSubview:_originalImgView];
    
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    _imgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_imgView];
}


/**
 * 从头获取一定长度
 */
- (void)testLongImageFromHead
{
    _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
    
    //第四种方法： NSFileHandle实例方法读取内容
    NSMutableData *mData = [NSMutableData data];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sky.jpg" ofType:nil];
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *_recieveData = [fh readDataOfLength:1024*100];
    [mData appendData:_recieveData];
    [fh closeFile];

    
    
    CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)_recieveData, NO);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
    _imgView.image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}

/**
 * 获取某一部分图片
 */
- (void)testLongImageSeek
{
    _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
    
    //第四种方法： NSFileHandle实例方法读取内容
    NSMutableData *mData = [NSMutableData data];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sky.jpg" ofType:nil];
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *_recieveData = [fh readDataOfLength:1024*4];
    [mData appendData:_recieveData];
    
    [fh closeFile];
    
    
    fh = [NSFileHandle fileHandleForReadingAtPath:path];
    [fh seekToFileOffset:1024*70];
    _recieveData = [fh readDataOfLength:1024*100];
    [mData appendData:_recieveData];
    _recieveData = mData.copy;
    [fh closeFile];
    
    
    CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)_recieveData, NO);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
    _imgView.image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
