enum Role {
  ADMIN,
  MAINTAINER,
  CLEANER,
  USER;

  String get displayName {
    switch (this) {
      case Role.ADMIN:
        return 'Administrador';
      case Role.MAINTAINER:
        return 'Mantenimiento';
      case Role.CLEANER:
        return 'Limpieza';
      case Role.USER:
        return 'Usuario';
    }
  }

  static String getDisplayNameFromString(String roleStr) {
    switch (roleStr.toUpperCase()) {
      case 'ADMIN': return 'Administrador';
      case 'MAINTAINER': return 'Mantenimiento';
      case 'CLEANER': return 'Limpieza';
      case 'USER': return 'Usuario';
      default: return roleStr;
    }
  }
}