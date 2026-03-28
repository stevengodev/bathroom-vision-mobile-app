enum Gender {
  MASCULINO,
  FEMENINO,
  UNISEX;

  String toDisplayString() {
    switch (this) {
      case Gender.MASCULINO:
        return 'Masculino';
      case Gender.FEMENINO:
        return 'Femenino';
      case Gender.UNISEX:
        return 'Unisex';
    }
  }
}
