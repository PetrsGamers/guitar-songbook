class SongSubmitValidator {
  static String? validateInputDefault(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  static String? validateBPM(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some number';
    }
    if (int.parse(value) < 30 || int.parse(value) > 200) {
      return "Enter valid range from 30 to 200";
    }
    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some number';
    }
    if (int.parse(value) < 0 || int.parse(value) > DateTime.now().year) {
      return "Enter valid range from 0 to ${DateTime.now().year}";
    }
    return null;
  }
}
