import 'package:flutter/material.dart';
import 'package:app/models/supplier.dart';

class ProviderCard extends StatefulWidget {
  const ProviderCard({
    super.key,
    required this.proveedor,
  });

  final Supplier proveedor;

  @override
  State<ProviderCard> createState() {
    return _ProviderCardState();
  }
}

class _ProviderCardState extends State<ProviderCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final proveedor = widget.proveedor;

    void toggleExpansion() {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 16,
      shadowColor: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryFixed,
              Theme.of(context).colorScheme.primaryFixedDim,
            ],
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  proveedor.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: toggleExpansion,
                  child: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 36,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  proveedor.category,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  label: Text(
                    proveedor.zone,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.location_city),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          label: Text(
                            proveedor.phone,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(Icons.phone),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          label: Text(
                            proveedor.email,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(Icons.mail),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          label: Text(
                            proveedor.address,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(Icons.location_pin),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
