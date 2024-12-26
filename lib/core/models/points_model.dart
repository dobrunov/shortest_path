class Points {
  final int x;
  final int y;

  Points(this.x, this.y);

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      json['x'] as int,
      json['y'] as int,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Points && x == other.x && y == other.y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => '($x, $y)';
}
