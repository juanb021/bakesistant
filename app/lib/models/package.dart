class Package {
  const Package({
    required this.name,
    required this.cost,
  });

  final String name;
  final double cost;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Package && other.name == name && other.cost == cost;
  }

  @override
  int get hashCode => name.hashCode ^ cost.hashCode;
}
