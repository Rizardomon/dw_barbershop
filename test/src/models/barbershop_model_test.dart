import 'package:dw_barbershop/src/models/barbershop_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BarbershopModel', () {
    test('fromJson should correctly parse a valid JSON map', () {
      final jsonMap = {
        'id': 1,
        'name': 'Sample Barbershop',
        'email': 'sample@email.com',
        'opening_days': ['Monday', 'Tuesday', 'Wednesday'],
        'opening_hours': [10, 12, 14],
      };

      final barbershop = BarbershopModel.fromMap(jsonMap);

      expect(barbershop.id, 1);
      expect(barbershop.name, 'Sample Barbershop');
      expect(barbershop.email, 'sample@email.com');
      expect(barbershop.openingDays, ['Monday', 'Tuesday', 'Wednesday']);
      expect(barbershop.openingHours, [10, 12, 14]);
    });

    test('fromJson should throw an ArgumentError for invalid JSON map', () {
      final invalidJsonMap = {
        'id': 1,
        'name': 'Invalid Barbershop',
        // Missing 'email' field
        'opening_days': ['Thursday', 'Friday'],
        'opening_hours': [9, 11],
      };

      expect(
        () => BarbershopModel.fromMap(invalidJsonMap),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
