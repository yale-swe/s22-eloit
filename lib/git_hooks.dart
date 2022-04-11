import "dart:io";

import "package:dart_pre_commit/dart_pre_commit.dart";
import "package:git_hooks/git_hooks.dart";

void main(List<String> arguments) {
  final params = {Git.preCommit: _preCommit};
  change(arguments, params);
}

Future<bool> _preCommit() async {
  hooks = await Hooks.create(); // adjust behaviour if neccessary
  final result = await hooks(); // run activated hooks on staged files
  return result.isSuccess; // report the result
}
