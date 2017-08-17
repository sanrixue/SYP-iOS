//
//  FileUtils+Report.h
//  YH-IOS
//
//  Created by lijunjie on 16/7/18.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "FileUtils.h"

@interface FileUtils (Report)

/**
 *  内部报表是否支持筛选功能
 *
 *  @param groupID    群组ID
 *  @param templateID 模板ID
 *  @param reportID   报表ID
 *
 *  @return 是否支持筛选功能
 */
+ (BOOL)reportIsSupportSearch:(NSString *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID;

/**
 *  内部报表 JavaScript 文件路径
 *
 *  @param groupID    群组ID
 *  @param templateID 模板ID
 *  @param reportID   报表ID
 *
 *  @return 文件路径
 */
+ (NSString *)reportJavaScriptDataPath:(NSString *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID;

/**
 *  内部报表具有筛选功能时，选项列表
 *
 *  @param groupID    群组ID
 *  @param templateID 模板ID
 *  @param reportID   报表ID
 *
 *  @return 选项列表
 */
+ (NSArray *)reportSearchItems:(NSString *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID;

/**
 *  内部报表具有筛选功能时，用户选择的选项，默认第一个选项
 *
 *  @param groupID    群组ID
 *  @param templateID 模板ID
 *  @param reportID   报表ID
 *
 *  @return 用户选择的选项，默认第一个选项
 */
+ (NSString *)reportSelectedItem:(NSString *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID;
@end
