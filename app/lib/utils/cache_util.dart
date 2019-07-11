import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CacheUtil {
  static CacheUtil _cacheUtil;

  // 工厂模式 : 单例公开访问点
  factory CacheUtil() => _getInstance();

  static CacheUtil get instance => _getInstance();

  static _getInstance() {
    if (null == _cacheUtil) {
      _cacheUtil = CacheUtil._interval();
    }
    return _cacheUtil;
  }

  // 私有构造函数
  CacheUtil._interval();

  ///加载缓存
  Future<double> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      print('缓存目录 ${tempDir.path}');
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      tempDir.list(followLinks: false, recursive: true).listen((file) {
        //打印每个缓存文件的路径
        print('缓存路径:  ${file.path}');
      });
      print('临时目录大小: ' + value.toString());
      return value;
    } catch (err) {
      print(err);
    }
    return 0;
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  ///清理缓存
  Future<double> clearCache() async {
    //此处展示加载loading
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      return await loadCache();
    } catch (e) {
      print(e);
    }
    return 0;
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}
