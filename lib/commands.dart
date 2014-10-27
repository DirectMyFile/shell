library shell.commands;

import "dart:async";
import "dart:io";

import "shell.dart";
import "package:console/console.dart";

final Map<String, Command> coreutils = {
  "ls": proxyCommand("ls"),
  "clear": proxyCommand("clear")
};

final Map<String, Command> builtins = {
  "exit": (Shell shell, List<String> args) {
    int code = 0;
    if (args.length > 1) {
      print("usage: exit [code]");
      return 1;
    }
    
    if (args.isNotEmpty) {
      try {
        code = int.parse(args[0]);
      } catch (e) {
        print("error: invalid exit code.");
        return 1;
      }
    }
    exit(code);
  },
  "set": (Shell shell, List<String> args) {
    if (args.isEmpty) {
      for (var key in shell.env.keys) {
        print("${key}=${shell.env[key]}");
      }
    } else if (args.length == 1) {
      var key = args[0];
      shell.env[key] = "";
    } else {
      var key = args[0];
      var valueList = new List.from(args)..removeRange(0, 1);
      shell.env[key] = valueList.join(" ");
    }
    return 0;
  },
  "unset": (Shell shell, List<String> args) {
    if (args.length != 1) {
      print("usage: unset <variable>");
      return 1;
    } else {
      var name = args[0];
      shell.env.remove(name);
      return 0;
    }
  }
};