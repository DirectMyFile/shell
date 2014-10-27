part of shell;

final RegExp _VAR_REGEX = new RegExp(r"\$(?:\{?)([^\s|\}]+)(?:\}?)");

class StringUtils {
  static String replace(String original, int index, String replacement, {int overwrite}) {
    StringBuffer str = new StringBuffer();
    if (index > 0) {
      str.write(original.substring(0, index));
    }

    if (overwrite == null) {
      overwrite = replacement.length;
    }

    str.write(replacement);
    if (overwrite > 0) {
      if (overwrite < original.length) {
        str.write(original.substring(index + overwrite));
      }
    } else {
      str.write(original.substring(index));
    }
    return str.toString();
  }
  
  static String remove(String original, int index, int length) {
    return replace(original, index, '', overwrite: length);
  }
}

String expandVariables(String input, Map<String, String> vars) {
  var originalInput = input;
  var varMatches = _VAR_REGEX.allMatches(input);
  
  for (var match in varMatches) {
    var variable = match.group(1);
    var matched = match.group(0);
    var value = vars.containsKey(variable) ? vars[variable] : "";
    var isBraced = matched.endsWith("}");
    var overwrite = isBraced ? matched.length : matched.length;
    input = StringUtils.replace(input, match.start, value, overwrite: overwrite);
  }
  
  return input;
}

Command proxyCommand(String executable) {
  return (Shell shell, List<String> args) {
    return Process.start(executable, args, environment: shell.env).then((process) {
      inheritIO(process);
      return process.exitCode;
    });
  };
}