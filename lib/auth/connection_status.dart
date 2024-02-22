enum AuthConnectionStatus {
  idle,
  waiting,
  done;

  operator |(AuthConnectionStatus other) => index | other.index;

  bool isWaiting() => this == AuthConnectionStatus.waiting;
  bool isDone() => this == AuthConnectionStatus.done;
  bool isIdle() => this == AuthConnectionStatus.idle;
  bool isDoneOrIdle() => this == AuthConnectionStatus.done || this == AuthConnectionStatus.idle;
}
