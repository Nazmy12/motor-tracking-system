import 'package:flutter_test/flutter_test.dart';

void main() {
  test('License plate regex matches with and without spaces', () {
    final regex = RegExp(r'\b[A-Z]\s?\d{4}\s?[A-Z]{3}\b');

    // Test without spaces
    expect(regex.hasMatch('B3962PLJ'), true);

    // Test with spaces
    expect(regex.hasMatch('B 3962 PLJ'), true);

    // Test with extra spaces (should still match the plate)
    expect(regex.hasMatch('B3962PLJ '), true); // trailing space
    expect(regex.hasMatch(' B3962PLJ'), true); // leading space

    // Test invalid formats
    expect(regex.hasMatch('B396PLJ'), false); // wrong digit count
    expect(regex.hasMatch('B3962PL'), false); // wrong letter count
    expect(regex.hasMatch('1234ABC'), false); // starts with digit
    expect(regex.hasMatch('B3962ABC1'), false); // extra character
  });
}
