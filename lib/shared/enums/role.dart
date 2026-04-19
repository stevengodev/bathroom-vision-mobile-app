enum Role {
  ADMIN,
  MAINTAINER,
  CLEANER;

  String get displayName {
    switch (this) {
      case Role.ADMIN:
        return 'Administrador';
      case Role.MAINTAINER:
        return 'Mantenimiento';
      case Role.CLEANER:
        return 'Limpieza';
    }
  }
}