library shell.commands;

import "dart:async";
import "dart:io";

import "shell.dart";
import "package:console/console.dart";

final Map<String, Command> coreutils = {
  "ls": proxyCommand("ls"),
  "clear": (Shell shell, List<String> args) {
    Console.eraseDisplay(0);
    return 0;
  }
};