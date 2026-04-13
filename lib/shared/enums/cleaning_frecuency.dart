enum CleaningFrequency {
  DIARO,
  SEMANAL;

  String toDisplayString() {
    switch (this) {
      case CleaningFrequency.DIARO:
        return 'Diario';
      case CleaningFrequency.SEMANAL:
        return 'Semanal';
    }
  }

}