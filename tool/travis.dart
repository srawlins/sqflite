import 'package:process_run/shell.dart';
import 'package:pub_semver/pub_semver.dart';

Future main() async {
  var shell = Shell();

  await shell.run('flutter doctor');

  final nnbdEnabled = dartVersion > Version(2, 11, 0, pre: '0');
  if (nnbdEnabled) {
    // Temp dart extra option. To remove once nnbd supported on stable without flags
    final dartExtraOptions = '--enable-experiment=non-nullable';
    // Needed for run and test
    final dartRunExtraOptions =
        '--enable-experiment=non-nullable --no-sound-null-safety';

    for (var dir in [
      'sqflite_common',
      'sqflite_common_ffi',
    ]) {
      shell = shell.pushd(dir);
      await shell.run('''
    
    dart $dartExtraOptions pub get
    dart $dartRunExtraOptions tool/travis.dart
    
        ''');
      shell = shell.popd();
    }
  } else {
    for (var dir in [
      'sqflite/example',
      'sqflite',
      'sqflite_test_app',
    ]) {
      shell = shell.pushd(dir);
      await shell.run('''
    
    flutter packages get
    dart tool/travis.dart
    
        ''');
      shell = shell.popd();
    }

    for (var dir in [
      'sqflite_common_test',
    ]) {
      shell = shell.pushd(dir);
      await shell.run('''
    
    pub get
    dart tool/travis.dart
    
        ''');
      shell = shell.popd();
    }
  }
}
