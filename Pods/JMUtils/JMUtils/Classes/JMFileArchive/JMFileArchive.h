//
//  JMFileArchive.h
//  JMUtils
//
//  Created by Thief Toki on 2021/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^JMFiltor)(id obj);

@interface JMFileArchive<T: NSObject*> : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *rootPath;

@property (nonatomic, strong, nullable) NSString *suffix;

@property (nonatomic, strong, nullable) T info;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name suffix:(NSString * _Nullable)suffix;

#pragma mark - 对目标文件的处理

- (NSString *)fullPath:(NSString *)fileName;

- (BOOL)save:(NSString *)fileName;

- (BOOL)remove:(NSString *)fileName;

- (NSObject *)read:(NSString *)fileName;

- (NSString *)dateString:(NSString *)fileName;
- (NSString *)dateString:(NSString *)fileName withFormat:(NSString *)dateFormat;

- (NSDictionary *)attributes:(NSString *)fileName;

#pragma mark - 文件批处理

- (NSArray *)fileList;
- (NSArray *)fileListUsingComparator:(NSComparator NS_NOESCAPE)cmptr;
- (NSArray *)fileListUsingFilter:(BOOL(^)(id obj, NSUInteger idx, BOOL *stop))filter;

- (BOOL)clean;
- (BOOL)cleanBeforeDate:(NSDate *)limitDate;
- (BOOL)cleanUsingLimiter:(JMFiltor NS_NOESCAPE)fltr;

@end

@interface JMFileArchiveForString : JMFileArchive<NSString *>

@end

@interface JMFileArchiveForData : JMFileArchive<NSData*>

@end

@interface JMFileArchiveForArray : JMFileArchive<NSArray*>

@end

@interface JMFileArchiveForDictionary : JMFileArchive<NSDictionary*>

@end

NS_ASSUME_NONNULL_END
