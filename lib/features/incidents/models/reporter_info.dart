class ReporterInfo {
  final String name;
  final String email;

  const ReporterInfo({
    required this.name,
    required this.email,
  });

  factory ReporterInfo.fromJson(Map<String, dynamic> json) {
    return ReporterInfo(
      name: json["name"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
    };
  }
}