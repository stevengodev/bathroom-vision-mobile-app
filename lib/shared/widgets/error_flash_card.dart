import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar errores como tarjetas flash
/// 
/// Uso:
/// ```dart
/// ErrorFlashCard.show(
///   context,
///   message: 'Error al cargar datos',
///   type: ErrorType.error,
/// );
/// ```
class ErrorFlashCard {
  /// Muestra una tarjeta flash de error
  static void show(
    BuildContext context, {
    required String message,
    ErrorType type = ErrorType.error,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final config = _getErrorConfig(type);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _ErrorContent(
          message: message,
          icon: config.icon,
          iconColor: config.iconColor,
        ),
        backgroundColor: config.backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  /// Muestra un error genérico
  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      type: ErrorType.error,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Muestra una advertencia
  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      type: ErrorType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Muestra un mensaje informativo
  static void info(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      type: ErrorType.info,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Muestra un mensaje de éxito
  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      type: ErrorType.success,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static _ErrorConfig _getErrorConfig(ErrorType type) {
    switch (type) {
      case ErrorType.error:
        return _ErrorConfig(
          icon: Icons.error_outline,
          iconColor: Colors.white,
          backgroundColor: const Color(0xFFDC2626), // Red-600
        );
      case ErrorType.warning:
        return _ErrorConfig(
          icon: Icons.warning_amber_outlined,
          iconColor: Colors.white,
          backgroundColor: const Color(0xFFF59E0B), // Amber-500
        );
      case ErrorType.info:
        return _ErrorConfig(
          icon: Icons.info_outline,
          iconColor: Colors.white,
          backgroundColor: const Color(0xFF3B82F6), // Blue-500
        );
      case ErrorType.success:
        return _ErrorConfig(
          icon: Icons.check_circle_outline,
          iconColor: Colors.white,
          backgroundColor: const Color(0xFF10B981), // Green-500
        );
    }
  }
}

/// Widget interno para el contenido de la tarjeta
class _ErrorContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;

  const _ErrorContent({
    required this.message,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Tipos de errores disponibles
enum ErrorType {
  error,
  warning,
  info,
  success,
}

/// Configuración interna de cada tipo de error
class _ErrorConfig {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  _ErrorConfig({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}