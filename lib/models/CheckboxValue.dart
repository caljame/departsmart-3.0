class CheckboxValue {
  bool isChecked = false;
  String title = "";
  String? suffix;

  CheckboxValue(this.isChecked, this.title);

  CheckboxValue.withSuffix(this.isChecked, this.title, this.suffix);
}
