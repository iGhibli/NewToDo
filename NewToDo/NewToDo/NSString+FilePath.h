//
//  NSString+FilePath.h
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FilePath)

/**
 * 根据文件名，返回文件在Documents下的路径
 *
 ＊ @param fileName 文件名字
 ＊
 ＊ @return 文件路径
 */
+ (NSString *)filePathInDocumentsWithFileName:(NSString *)fileName;

@end
