import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/repository/networking_repository.dart';
import 'package:pantry_recipe_flutter/viewModels/loading_view_controller.dart';

class IconButtonForDownload extends HookConsumerWidget {
  const IconButtonForDownload({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: () async{
        await ref.read(loadingServiceProvider.notifier).wrap(ref.read(networkingRepository).download());
      },
    );
  }
}