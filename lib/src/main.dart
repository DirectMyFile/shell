part of shell;

typedef Command(Shell shell, List<String> args);
typedef void NoSuchCommandHandler(Shell shell, String command, List<String> args);
typedef String PromptCreator();

class Shell {
  final Map<String, Command> commands = {};
  final Map<String, String> env = {};
  
  PromptCreator promptCreator = () {
    var path = Directory.current.path;
    var homeDir = Platform.environment["HOME"];
    if (path.startsWith(homeDir)) {
      path = path.replaceFirst(homeDir, "~");
    }
    var user = Platform.environment["USER"];
    var host = Platform.localHostname;
    return "[${user}@${host} ${path}]\$ ";
  };
  
  NoSuchCommandHandler noSuchCommand = _printNoSuchCommand;
  
  Shell();
  
  void start() {
    printPrompt();
    StreamSubscription<List<int>> sub;
    sub = stdin.listen((data) {
      var line = UTF8.decode(data);
      line = line.substring(0, line.length - 1);
      sub.pause();
      handle(line).then((_) {
        sub.resume();
        printPrompt();
      });
    });
  }
  
  void printPrompt() {
    stdout.write(promptCreator());
  }
  
  static void _printNoSuchCommand(Shell shell, String command, List<String> args) {
    print("No Such Command: ${command}");
  }
  
  void applyCommands(Map<String, Command> commandSet) {
    commands.addAll(commandSet);
  }
  
  Future handle(String input) {
    if (input.trim().isEmpty) {
      return new Future.value();
    }
    
    var split = input.split(" ");
    
    String cmd = split[0];
    List<String> args = new List.from(split)..removeAt(0);
    
    if (commands.containsKey(cmd)) {
      var command = commands[cmd];
      var result = command(this, args);
      
      Future future;
      
      if (result is int) {
        int exitCode = result;
        future = new Future.value(exitCode);
      } else if (result is Future<int>) {
        future = result;
      } else {
        throw new Exception("Invalid Command Result: ${result}");
      }
      
      return future.then((exit) {
        setEnv("?", exit);
      });
    } else {
      if (noSuchCommand != null) {
        noSuchCommand(this, cmd, args);
      } else {
        _printNoSuchCommand(this, cmd, args);
      }
      return new Future.value();
    }
  }
  
  void setEnv(String key, value) {
    env[key] = value.toString();
  }
}