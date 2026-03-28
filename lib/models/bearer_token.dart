class BearerToken {
  String access;
  String refresh;

  BearerToken({required this.access, required this.refresh});

  factory BearerToken.fromJson(Map<String, dynamic> json) {
    return BearerToken(
      access: json["access_token"],
      refresh: json["refresh_token"],
    );
  }

  Map<String, dynamic> toJson() => {"access": access, "refresh": refresh};

  @override
  String toString() {
    return '{access: $access, refresh: $refresh}';
  }
}
