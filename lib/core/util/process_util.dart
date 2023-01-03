import 'package:async/async.dart';

class ProcessUtil {
  static ProcessUtil instance = ProcessUtil._internal();

  CancelableOperation? cancelableOperation;

  factory ProcessUtil() {
    return instance;
  }

  ProcessUtil._internal();

  void addProcess(Function currentFunction) {
    if (cancelableOperation != null) {
      cancelableOperation?.cancel();
    }
    cancelableOperation =
        CancelableOperation.fromFuture(currentFunction.call(), onCancel: () {
      cancelableOperation = null;
    });
  }

  void cancelProcess() {
    cancelableOperation?.cancel();
  }
}
