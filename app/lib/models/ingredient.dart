class Ingredient {
  const Ingredient({
    required this.name,
    required this.cost,
  });

  final String name;
  final double cost;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ingredient && other.name == name && other.cost == cost;
  }

  @override
  int get hashCode => name.hashCode ^ cost.hashCode;
}
