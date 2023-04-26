import 'dart:math';

import 'package:intl/intl.dart';

extension Decimals on double {
  String fixedDecimals(int decimals, {bool removeZeroDecimals = true}) {
    num mod = pow(10.0, decimals);
    double result = ((this * mod).round().toDouble() / mod);
    if (removeZeroDecimals && result - (result.truncate()) == 0.0) decimals = 0;
    return result.toStringAsFixed(decimals);
  }

  double decimals(int decimals) {
    num mod = pow(10.0, decimals);
    return ((this * mod).round().toDouble() / mod);
  }

  String fixedDecimalFormat(int decimals, {bool removeZeroDecimals = true}) {
    num mod = pow(10.0, decimals);
    double result = ((this * mod).round().toDouble() / mod);
    var numberFormat = NumberFormat();
    numberFormat.maximumFractionDigits = decimals;
    if (!removeZeroDecimals) numberFormat.minimumFractionDigits = decimals;
    return numberFormat.format(result);
  }
}

extension IntDecimals on int {
  String fixedDecimals(int decimals, {bool removeZeroDecimals = true}) {
    num mod = pow(10.0, decimals);
    double result = ((this * mod).round().toDouble() / mod);
    if (removeZeroDecimals && result - (result.truncate()) == 0.0) decimals = 0;
    return result.toStringAsFixed(decimals);
  }

  String fixedDecimalFormat(int decimals, {bool removeZeroDecimals = true}) {
    num mod = pow(10.0, decimals);
    double result = ((this * mod).round().toDouble() / mod);
    var numberFormat = NumberFormat();
    numberFormat.maximumFractionDigits = decimals;
    return numberFormat.format(result);
  }

  String toNetworkHashrate() {
    var hashrate = (this * 1000000).toDouble();
    if (hashrate < 1000000) {
      return '0 Sol/s';
    }
    var byteUnits = [' Sol/s', ' KSol/s', ' MSol/s', ' GSol/s', ' TSol/s', ' PSol/s'];
    var i = ((log(hashrate / 1000) / log(1000)) - 1).floor();
    hashrate = (hashrate / 1000) / pow(1000, i + 1);
    return '${hashrate.fixedDecimals(2)}${byteUnits[i]}';
  }
}

extension Rounding on double {
  /// Rounds [n] up to the nearest multiple of [multiple].
  double roundUpToMultiple(num multiple) {
    assert(this >= 0);
    assert(multiple > 0);
    return (this / multiple).ceilToDouble() * multiple;
  }

  /// Rounds [n] down to the nearest multiple of [multiple].
  double roundDownToMultiple(num multiple) {
    assert(this >= 0);
    assert(multiple > 0);
    return (this / multiple).floorToDouble() * multiple;
  }

  double remap(double inMin, double inMax, double outMin, double outMax) {
    return (this - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }

  /// Rounds [n] to its most significant digit.
  double roundToMostSignificantDigit() {
    assert(this >= 0);
    var numDigits = toString().length;
    var magnitude = pow(10, numDigits - 1) as int;
    return roundUpToMultiple(magnitude);
  }
}
