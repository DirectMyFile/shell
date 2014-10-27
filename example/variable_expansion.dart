import "package:shell/shell.dart";

void main() {
  print(expandVariables(r"exit ${?}", {
    "?" : "1"
  }));
  
  print(expandVariables(r"echo $text", {
    "text": "Hello World"
  }));
  
  print(expandVariables(r"echo $text", {
    "text": "Hi"
  }));
}