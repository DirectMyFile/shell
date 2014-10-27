import "package:shell/shell.dart";
import "package:shell/commands.dart";

void main() {
  var shell = new Shell();
  shell.applyCommands(coreutils);
  shell.start();
}