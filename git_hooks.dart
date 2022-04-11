import 'package:dart_pre_commit/dart_pre_commit.dart';
import 'package:git_hooks/git_hooks.dart';
import 'package:riverpod/riverpod.dart';
// import 'dart:io';

void main(List<String> arguments) {
  // ignore: omit_local_variable_types
  Map<Git, UserBackFun> params = {Git.preCommit: _preCommit};
  GitHooks.call(arguments, params);
}

Future<bool> _preCommit() async {
  // optional: create an IoC-Container for easier initialization of the hooks
  final container = ProviderContainer();

  // obtain the hooks instance from the IoC with your custom config
  final hook = await container.read(
    HooksProvider.hookProvider(
      const HooksConfig(format: true),
    ).future,
  );

  final result = await hook(); // run activated hooks on staged files
  return result.isSuccess; // report the result
}
