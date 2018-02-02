//
//  main.m
//  findtheinterface
//
//  Created by 张超 on 2017/5/12.
//  Copyright © 2017年 orzer. All rights reserved.
//

#import <Foundation/Foundation.h>
NSArray* findInterface (NSString* text);

BOOL bFormat;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        if(argc<=1) return 0;
        NSString* cmd = [[NSString alloc] initWithCString:argv[1] encoding:NSUTF8StringEncoding];
        if ([cmd isEqualToString:@"-f"]) {
            bFormat = YES;
        }
        NSInteger i = bFormat ? 2 : 1;
        NSString* filePath = [[NSString alloc] initWithCString:argv[i] encoding:NSUTF8StringEncoding];
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            NSLog(@"文件不存在");
            return 0;
        }
        NSString* s = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSString* f = [findInterface(s) componentsJoinedByString:@"\n"];
        NSLog(@"%@",f);
    }
    return 0;
}

NSString* format (NSString* string){
    @autoreleasepool {
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@";" withString:@""];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
        
        string = [components componentsJoinedByString:@" "];
        return string;
    }
}

NSArray* findInterface (NSString* text)
{
    @autoreleasepool {
        //复制代码
        //        NSString *regex = @"-\\s?\\(.*?\\).*?(?=\\n|$|\\{)";
        NSString *regex = @"(-|\\+)\\s?\\(.*?\\).*?(?=\\{)";
        regex = @"(-|\\+)\\s?\\(.*?\\)[^;]*?(?=\\{)";
        NSString *str = text;
        NSError *error;
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
        // 对str字符串进行匹配
        NSArray *matches = [regular matchesInString:str
                                            options:0
                                              range:NSMakeRange(0, str.length)];
        
        NSMutableArray* result = [NSMutableArray arrayWithCapacity:matches.count];
        // 遍历匹配后的每一条记录
        for (NSTextCheckingResult *match in matches) {
            NSRange range = [match range];
            NSString *mStr = [str substringWithRange:range];
            if (bFormat) {
                mStr = format(mStr); //这个方法在下面的内容zh
            }
            [result addObject:mStr];
        }
        
        return [result copy];
    }
}

