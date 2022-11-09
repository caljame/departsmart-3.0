class Country {
  final String code;
  final String name;
  final String aka;

  const Country.from(this.code, this.name, {this.aka = ""});
}
