import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/repository/user_repository.dart';
import 'package:pantry_recipe_flutter/screens/singin_and_signup_screen.dart';

class IconButtonForSignOut extends HookConsumerWidget {
  const IconButtonForSignOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        ref.read(userRepository).signOutUser();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInAndSingUpScreen(),
          ),
        );
      },
    );
  }
}