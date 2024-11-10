import 'package:app/models/package.dart';
import 'package:app/providers/packages_provider.dart';
import 'package:app/widgets/empaque/empaque_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmpaqueInfo extends ConsumerStatefulWidget {
  const EmpaqueInfo({
    super.key,
    required this.empaque,
  });

  final Package empaque;

  @override
  ConsumerState<EmpaqueInfo> createState() => _EmpaqueInfoState();
}

class _EmpaqueInfoState extends ConsumerState<EmpaqueInfo> {
  void _openAddEmpaqueOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => EmpaqueForm(
        empaque: widget.empaque,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.empaque.name),
      onDismissed: (direction) {
        ref.watch(packagesProvider.notifier).deletePackage(widget.empaque.name);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Empaque eliminado!',
            ),
          ),
        );
      },
      child: InkWell(
        onTap: _openAddEmpaqueOverlay,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.empaque.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                child: Text(
                  '\$ ${widget.empaque.cost.toString()}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
