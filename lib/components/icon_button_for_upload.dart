import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/repository/networking_repository.dart';

import '../viewModels/loading_view_controller.dart';

class IconButtonForUpload extends HookConsumerWidget {
  const IconButtonForUpload({
    required this.memoId,
    Key? key,
  }) : super(key: key);

  final String? memoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.upload),
      onPressed: () async{
        await ref.read(loadingServiceProvider.notifier).wrap(ref.read(networkingRepository).upload(memoId));
      },
    );
  }
}