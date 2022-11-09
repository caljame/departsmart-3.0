class TimeZone {
  final int zoneId;
  final String abbreviation;
  final double timeStart;
  final int gmtOffset;
  final bool dst;

  const TimeZone.from(
      this.zoneId, this.abbreviation, this.timeStart, this.gmtOffset, this.dst);
}
