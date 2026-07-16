import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void runAppWithErrorHandling(Future<void> Function() appInitializer) {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 拦截 Flutter 框架错误
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _handleError('FlutterError', details.exceptionAsString(), details.stack?.toString() ?? '');
  };

  // 2. 拦截所有异步错误
  PlatformDispatcher.instance.onError = (error, stack) {
    _handleError('AsyncError', error.toString(), stack.toString());
    return true;
  };

  // 3. 启动初始化
  _bootApp(appInitializer);
}

Future<void> _bootApp(Future<void> Function() appInitializer) async {
  try {
    await appInitializer();
  } catch (e, s) {
    if (kDebugMode) {
      runApp(_RawErrorApp(error: e.toString(), stackTrace: s.toString()));
    } else {
      runApp(const Material(child: SizedBox()));
    }
  }
}

void _handleError(String title, String error, String stackTrace) {
  if (!kDebugMode) return;

  // 只要 Get.context 不为空，说明 App 已经正常跑起来了
  // (不管这个错误是何时爆发的，只要到了这里，就说明事件循环已经把它抛出来了)
  if (Get.context != null) {
    // 必须用 addPostFrameCallback，确保不在 Build 阶段弹框，避免引发重入异常
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Get.isDialogOpen ?? false) return;
        Get.dialog(
          PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text('💥 $title'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    const Text('Error:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    Text(error),
                    const SizedBox(height: 16),
                    const Text('StackTrace:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(stackTrace, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: Get.back, child: const Text('关闭')),
              ],
            ),
          ),
        );
      } catch (e) {
        // 兜底：如果弹框过程中还报错，直接打印
        debugPrint('🚨 弹框失败，原始错误如下:');
        debugPrint('Error: $error');
        debugPrint('StackTrace: $stackTrace');
      }
    });
  } else {
    // 如果 Get.context 为空，说明 runApp 还没执行完就崩了
    // 直接接管屏幕
    debugPrint('🚨 [$title] App 未启动阶段崩溃:');
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
    runApp(_RawErrorApp(error: "[$title] $error", stackTrace: stackTrace));
  }
}

/// 原生错误展示页（仅在 runApp 之前崩溃时使用）
class _RawErrorApp extends StatelessWidget {
  final String error;
  final String stackTrace;

  const _RawErrorApp({required this.error, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('发生致命错误', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 20),
              Text(error),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(stackTrace, style: const TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}