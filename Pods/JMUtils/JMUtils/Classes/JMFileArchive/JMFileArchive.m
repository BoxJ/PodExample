//
//  JMFileArchive.m
//  JMUtils
//
//  Created by Thief Toki on 2021/1/11.
//

#import "JMFileArchive.h"

@implementation JMFileArchive

#pragma mark - shared

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name suffix:nil];
}

- (instancetype)initWithName:(NSString *)name suffix:(NSString *)suffix {
    self = [super init];
    if (self) {
        self.name = name;
        self.suffix = suffix;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.rootPath = [paths objectAtIndex:0];
        self.rootPath = [self.rootPath stringByAppendingString:@"/"];
        
        self.rootPath = [self.rootPath stringByAppendingFormat:@"%@/", NSStringFromClass([self class])];
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.rootPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.rootPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        
        self.rootPath = [self.rootPath stringByAppendingFormat:@"%@/", self.name];
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.rootPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.rootPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
    }
    return self;
}

#pragma mark - 对目标文件的处理

- (NSString *)fullPath:(NSString *)fileName {
    NSString *fullName = [fileName copy];
    if (self.suffix && ![fullName hasSuffix:self.suffix]) {
        fullName = [NSString stringWithFormat:@"%@.%@", fullName, self.suffix];
    }
    NSString *filePath = [self.rootPath stringByAppendingFormat:@"/%@", fullName];
    return filePath;
}

- (BOOL)save:(NSString *)fileName {
    if (!self.info) return false;
    
    NSString *fullPath = [self fullPath:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fullPath contents:nil attributes:nil];
    }
    
    if ([self.info isKindOfClass:[NSString class]]) {
        return [(NSString *)self.info writeToFile:fullPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else if ([self.info isKindOfClass:[NSData class]]) {
        return [(NSData *)self.info writeToFile:fullPath atomically:YES];
    } else if ([self.info isKindOfClass:[NSArray class]]) {
        return [(NSArray *)self.info writeToFile:fullPath atomically:YES];
    } else if ([self.info isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)self.info writeToFile:fullPath atomically:YES];
    } else {
        return false;
    }
}

- (BOOL)remove:(NSString *)fileName {
    NSString *fullPath = [self fullPath:fileName];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
    return !error;
}

- (NSObject *)read:(NSString *)fileName {
    return nil;
}

- (NSString *)dateString:(NSString *)fileName {
    NSDate *fileDate = [self attributes:fileName][NSFileModificationDate];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyyMMdd_HHmmss";
    return [dateFormater stringFromDate:fileDate];
}

- (NSString *)dateString:(NSString *)fileName withFormat:(NSString *)dateFormat {
    NSDate *fileDate = [self attributes:fileName][NSFileModificationDate];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = dateFormat;
    return [dateFormater stringFromDate:fileDate];
}

- (NSDictionary *)attributes:(NSString *)fileName {
    NSString *fullPath = [self fullPath:fileName];
    
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
    if (error) {
        return nil;
    } else {
        return attributes;
    }
}

#pragma mark - 文件批处理

- (NSArray *)fileList {
    __weak typeof(self) weakSelf = self;
    return [self fileListUsingComparator:^NSComparisonResult(NSString *fileName1, NSString *fileName2) {
        NSDate *fileDate1 = [weakSelf attributes:fileName1][NSFileModificationDate];
        NSDate *fileDate2 = [weakSelf attributes:fileName2][NSFileModificationDate];
        return [fileDate1 compare:fileDate2] * -1;
    }];
}

- (NSArray *)fileListUsingComparator:(NSComparator NS_NOESCAPE)cmptr {
    NSArray *fileNames = [[NSFileManager defaultManager] subpathsAtPath:self.rootPath];
    fileNames = [fileNames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return (NSComparisonResult)cmptr(obj1, obj2);
    }];
    return fileNames;
}

- (NSArray *)fileListUsingFilter:(BOOL(^)(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop))filter {
    NSMutableArray *list = [NSMutableArray array];
    
    NSArray *fileNames = [[NSFileManager defaultManager] subpathsAtPath:self.rootPath];
    [fileNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (filter(obj, idx, stop)) {
            [list addObject:obj];
        }
    }];
    
    return [list copy];
}

- (BOOL)clean {
    return [self cleanUsingLimiter:^BOOL(id  _Nonnull obj) {
        return YES;
    }];
}

- (BOOL)cleanBeforeDate:(NSDate *)limitDate {
    __weak typeof(self) weakSelf = self;
    return [self cleanUsingLimiter:^BOOL(NSString *fileName) {
        NSDate *fileDate = [weakSelf attributes:fileName][NSFileModificationDate];
        switch ([fileDate compare:limitDate]) {
            case NSOrderedAscending: {
                return YES;
                break;
            }
            default: {
                return NO;
                break;
            }
        }
    }];
}

- (BOOL)cleanUsingLimiter:(JMFiltor NS_NOESCAPE)fltr {
    NSArray *fileNames = [[NSFileManager defaultManager] subpathsAtPath:self.rootPath];
    
    BOOL result = YES;
    for (NSString *fileName in fileNames) {
        if (fltr(fileName)) {
            result &= [self remove:fileName];
        }
    }
    return result;
}

@end

@implementation JMFileArchiveForString

- (nonnull NSString *)read:(nonnull NSString *)fileName {
    NSString *fullPath = [self fullPath:fileName];
    self.info = [[NSString alloc] initWithContentsOfFile:fullPath
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
    return self.info;
}

@end

@implementation JMFileArchiveForData

- (nonnull NSData *)read:(nonnull NSString *)fileName {
    NSString *fullPath = [self fullPath:fileName];
    self.info = [[NSData alloc] initWithContentsOfFile:fullPath];
    return self.info;
}

@end

@implementation JMFileArchiveForArray

- (nonnull NSArray *)read:(nonnull NSString *)fileName {
    NSString *fullPath = [self fullPath:fileName];
    self.info = [[NSArray alloc] initWithContentsOfFile:fullPath];
    return self.info;
}

@end

@implementation JMFileArchiveForDictionary

- (nonnull NSDictionary *)read:(nonnull NSString *)fileName {
    NSString *fullPath = [self fullPath:fileName];
    self.info = [[NSDictionary alloc] initWithContentsOfFile:fullPath];
    return self.info;
}

@end
