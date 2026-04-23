enum CleaningFrequency {
  DIARIO,
  SEMANAL;

  String toDisplayString() {
    switch (this) {
      case CleaningFrequency.DIARIO:
        return 'Diario';
      case CleaningFrequency.SEMANAL:
        return 'Semanal';
    }
  }

}