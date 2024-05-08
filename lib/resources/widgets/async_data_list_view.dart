import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgp/models/base.dart';

class AsyncDataListView extends ConsumerWidget {
  const AsyncDataListView(
      {super.key, required this.data, this.listTile, this.providerNotifier});
  final AsyncValue data;
  final Function? listTile;
  final Refreshable? providerNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(providerNotifier as ProviderListenable);

    return data.when(
      data: (data) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: data.length ?? 0,
        itemBuilder: (_, index) => listTile != null
            ? listTile!(context, data[index], service)
            : listviewTile(data[index]),
      ),
      error: (error, stackTrace) => Center(child: Text("Error: $error")),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget listviewTile(Base modal) {
    return ListTile(
      leading: Text('${modal.id}'),
      title: const Text("Title"),
      // onTap: ,
      subtitle: const Column(
        children: [
          Text("Subtitle 1"),
          Text("Subtitle 2"),
        ],
      ),
    );
  }
}
