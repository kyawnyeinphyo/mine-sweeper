class GameInfo {
  late int row, column, totalBomb, diffuser;
  late int durationInMinute;

  GameInfo.defaultSetting()
      : row = 10,
        column = 10,
        totalBomb = 10,
        diffuser = 2,
        durationInMinute = 0;

  GameInfo();
}
