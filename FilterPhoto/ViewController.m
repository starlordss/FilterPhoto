//
//  ViewController.m
//  FilterPhoto
//
//  Created by Zahi on 2017/12/27.
//  Copyright © 2017年 Zahi. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

//1032 × 762px
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imgViews;

@end

@implementation ViewController {
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imgViews = [NSMutableArray array];
    [self initImageView];
    [self convertTest];
    [self convertToGrayImage];
    [self convertToInvertColor];
    [self convertToInvertColor_02];
    [self convertToWhitenImage];
}

/// 美白
- (void)convertToWhitenImage {
    UIImage *image = [UIImage imageNamed:@"demo.png"];
    unsigned char *imageData = [self convertUImageToData:image];
    unsigned char *data = [self whitenImageWithImageData:imageData width:image.size.width height:image.size.height];
    _imgViews[5].image = [self converDataToUIImage:data image:image];
}

/// 图片颜色反转
- (void)convertToInvertColor {
    UIImage *image = [UIImage imageNamed:@"demo.png"];
    unsigned char *imageData = [self convertUImageToData:image];
    unsigned char *imageDataNew = [self invertColorWithImageData:imageData width:image.size.width height:image.size.height];
    _imgViews[3].image = [self converDataToUIImage:imageDataNew image:image];
}
- (void)convertToInvertColor_02 {
    UIImage *image = [UIImage imageNamed:@"demo.png"];
    unsigned char *imageData = [self convertUImageToData:image];
    unsigned char *imageData2 = [self grayImageWithData:imageData width:image.size.width height:image.size.height];
    unsigned char *imageDataNew = [self invertColorWithImageData:imageData2 width:image.size.width height:image.size.height];
    _imgViews[4].image = [self converDataToUIImage:imageDataNew image:image];
}

/// 转为灰色图片
- (void)convertToGrayImage {
    UIImage *image = [UIImage imageNamed:@"demo.png"];
    unsigned char *imageData = [self convertUImageToData:image];
    unsigned char *imageDataLater = [self grayImageWithData:imageData width:image.size.width height:image.size.height];
    _imgViews[2].image = [self converDataToUIImage:imageDataLater image:image];
    
}


- (unsigned char *)whitenImageWithImageData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 1 分配内存空间
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char) * 4);
    // 填充内存
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    NSArray *baseColors = @[@"55", @"110", @"155", @"185", @"220", @"240", @"250", @"255"];
    NSMutableArray *tempColors = [NSMutableArray array];
    int preNum = 0;
    for (int i = 0; i < 8 ; i++) {
        int num = [baseColors[i] intValue];
        float step = 0;
        if (i == 0) {
            step = num / 32.0;
        } else {
            step = (num - preNum) / 32.0;
        }
        for (int j = 0; j < 32; j++) {
            int nNum = 0;
            if (i == 0) {
                nNum = (int)(j * step);
            } else {
                nNum = (int)(preNum + j * step);
            }
            NSString *numStr = [NSString stringWithFormat:@"%d",nNum];
            [tempColors addObject:numStr];
            
        }
        preNum = num;
    }
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIdx = h * width + w;
            // 计算r g b的值
            unsigned char bitmapRed   = *(imageData + imageIdx * 4);
            unsigned char bitmapGreen = *(imageData + imageIdx * 4 + 1);
            unsigned char bitmapBlue  = *(imageData + imageIdx * 4 + 2);
            
            unsigned char red = [tempColors[bitmapRed] intValue];
            unsigned char green = [tempColors[bitmapGreen] intValue];
            unsigned char blue = [tempColors[bitmapBlue] intValue];
            
            memset(resultData + imageIdx * 4, red, 1);
            memset(resultData + imageIdx * 4 + 1, green, 1);
            memset(resultData + imageIdx * 4 + 2, blue, 1);
            
        }
    }
    return resultData;
}

- (unsigned char *)invertColorWithImageData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 1 分配内存空间
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char) * 4);
    // 填充内存
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIdx = h * width + w;
            // 计算r g b的值
            unsigned char bitmapRed   = *(imageData + imageIdx * 4);
            unsigned char bitmapGreen = *(imageData + imageIdx * 4 + 1);
            unsigned char bitmapBlue  = *(imageData + imageIdx * 4 + 2);
            // 反转
            unsigned char bitmapRedAfter = 255 - bitmapRed;
            unsigned char bitmapGreenAfter = 255 - bitmapGreen;
            unsigned char bitmapBlueAftre = 255 - bitmapBlue;
            // 填充内存
            memset(resultData + imageIdx * 4, bitmapRedAfter, 1);
            memset(resultData + imageIdx * 4 + 1, bitmapGreenAfter, 1);
            memset(resultData + imageIdx * 4 + 2, bitmapBlueAftre, 1);
        }
        
    }
    return resultData;
}

- (unsigned char *)grayImageWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 1 分配内存空间
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char) * 4);
    // 填充内存
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIdx = h * width + w;
            // 计算r g b的值
            unsigned char bitmapRed   = *(imageData + imageIdx * 4);
            unsigned char bitmapGreen = *(imageData + imageIdx * 4 + 1);
            unsigned char bitmapBlue  = *(imageData + imageIdx * 4 + 2);
            int bitmap = bitmapRed * 77/255 + bitmapGreen * 151/255 + bitmapBlue * 88/255;
            unsigned char res = (bitmap > 255)? 255:bitmap;
            memset(resultData + imageIdx * 4, res, 1);
            memset(resultData + imageIdx * 4 + 1, res, 1);
            memset(resultData + imageIdx * 4 + 2, res, 1);
        }
        
    }
    return resultData;
}


- (void)convertTest {
    UIImage *image = [UIImage imageNamed:@"demo.png"];
    unsigned char *imageData = [self convertUImageToData:image];
    UIImage *laterImage = [self converDataToUIImage:imageData image:image];
    _imgViews[1].image = laterImage;
    
    
}
- (void)initImageView {
    // 图片视图的宽
    CGFloat viewW = 150;
    // 图片视图的高
    CGFloat viewH = 150 * 762 / 1032;
    // 计算出每列之间的间距
    CGFloat marginX = (CGRectGetWidth(self.view.frame) - 2 * viewW) / 3;
    for (int i = 0; i < 6; i++) {
        // 列索引
        int col = i % 2;
        // 行索引
        int row = i / 2;
        // X
        CGFloat viewX = marginX + (marginX + viewW) * col;
        // Y
        CGFloat viewY = marginX + (marginX + viewH) * row;
        UIImageView *imgView = [[UIImageView alloc] init];
        if (i == 0) imgView.image = [UIImage imageNamed:@"demo.png"];
        
        imgView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        [self.view addSubview:imgView];
        [_imgViews addObject:imgView];
    }
}

- (unsigned char*)convertUImageToData:(UIImage *)image {
    // 1.转为CGImage
    CGImageRef imgRef = image.CGImage;
    CGSize imgSize = image.size;
    // 2.颜色空间
    CGColorSpaceRef colorSpeceRef = CGColorSpaceCreateDeviceRGB();
    // 3.分配bit空间: 每个像素4Byte  A R G B 像素的个数 = 宽 * 高
    void *data = malloc(imgSize.width * imgSize.height * 4);
    
    // 4.CGBitmap
    /**
     * 参数一: data
     * 参数二: 宽
     * 参数三: 高
     * 参数四: bit
     * 参数五: 颜色空间
     * 参数六: RGBA | 32位大字节序格式
     */
    // 上下文
    CGContextRef ctx = CGBitmapContextCreate(data, imgSize.width, imgSize.height, 8, 4 * imgSize.width, colorSpeceRef, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    // 5.渲染
    CGContextDrawImage(ctx, CGRectMake(0, 0, imgSize.width, imgSize.height), imgRef);
    // 释放
    CGColorSpaceRelease(colorSpeceRef);
    CGContextRelease(ctx);
    return data;
}
- (UIImage *)converDataToUIImage:(unsigned char*)imageData image:(UIImage *)image {
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    NSInteger dataLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imageData, dataLength, NULL);
    int bitsPerCompoent = 8;
    int bitsPerPiexl = 32;
    int bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpeceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imgRef = CGImageCreate(width, height, bitsPerCompoent, bitsPerPiexl, bytesPerRow, colorSpeceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CFRelease(imgRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpeceRef);
    return img;
}
@end
