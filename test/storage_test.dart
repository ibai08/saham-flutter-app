import 'package:flutter_test/flutter_test.dart';
import 'package:saham_01_app/core/getStorage.dart';

void main() {
  group('StorageController Tests', () {
    test('Initialize GetStorage', () async {
      final storageController = StorageController.instance;
      await storageController.init();

      expect(storageController.init(), true);
    });

    test('Get Storage Box', () async {
      final storageController = StorageController.instance;
      final boxName = 'testBox';
      final storageBox = storageController.getBox(boxName);

      expect(storageBox, boxName);
    });

    // Add more tests for other functions in StorageController if needed.
  });

  group('SharedBoxHelper Tests', () {
    test('Get All Data', () async {
      final boxName = 'testBox';
      final sharedBoxHelper = SharedBoxHelper(boxName: boxName);

      final allData = await sharedBoxHelper.getAll();

      // Add your assertions based on the expected result of getAll().
    });

    // Add more tests for other functions in SharedBoxHelper if needed.
  });

  group('SharedHelper Tests', () {
    test('Get Box', () async {
      final sharedHelper = SharedHelper.instance;
      final boxName = 'testBox';
      final sharedBoxHelper = sharedHelper.getBox(boxName);

      expect(sharedBoxHelper.boxName, boxName);
    });

    // Add more tests for other functions in SharedHelper if needed.
  });
}