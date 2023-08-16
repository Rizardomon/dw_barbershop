import 'package:dw_barbershop/src/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModelADM', () {
    test('fromJson should create a UserModelADM from valid JSON', () {
      final json = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'avatar': 'avatar_url',
        'work_days': ['Mon', 'Tue'],
        'work_hours': [9, 10, 11],
      };

      final userModel = UserModelADM.fromMap(json);

      expect(userModel.id, 1);
      expect(userModel.name, 'John Doe');
      expect(userModel.email, 'john@example.com');
      expect(userModel.avatar, 'avatar_url');
      expect(userModel.workDays, ['Mon', 'Tue']);
      expect(userModel.workHours, [9, 10, 11]);
    });

    test('fromJson should throw ArgumentError for invalid JSON', () {
      final json = {
        // Invalid JSON without 'id', 'name', and 'email'
        'avatar': 'avatar_url',
      };

      expect(() => UserModelADM.fromMap(json), throwsArgumentError);
    });
  });

  group('UserModelEmployee', () {
    test('fromJson should create a UserModelEmployee from valid JSON', () {
      final json = {
        'id': 2,
        'name': 'Jane Smith',
        'email': 'jane@example.com',
        'barbershop_id': 123,
        'work_days': ['Wed', 'Thu'],
        'work_hours': [13, 14],
        'avatar': 'avatar_url',
      };

      final userModel = UserModelEmployee.fromMap(json);

      expect(userModel.id, 2);
      expect(userModel.name, 'Jane Smith');
      expect(userModel.email, 'jane@example.com');
      expect(userModel.barbershopId, 123);
      expect(userModel.workDays, ['Wed', 'Thu']);
      expect(userModel.workHours, [13, 14]);
      expect(userModel.avatar, 'avatar_url');
    });

    test('fromJson should throw ArgumentError for invalid JSON', () {
      final json = {
        // Invalid JSON without 'id', 'name', 'email', 'barbershop_id', 'work_days', and 'work_hours'
        'avatar': 'avatar_url',
      };

      expect(() => UserModelEmployee.fromMap(json), throwsArgumentError);
    });
  });
}
