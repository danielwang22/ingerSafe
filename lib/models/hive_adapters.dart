import 'package:hive/hive.dart';
import 'report_model.dart';

class RiskLevelAdapter extends TypeAdapter<RiskLevel> {
  @override
  final int typeId = 0;

  @override
  RiskLevel read(BinaryReader reader) {
    final index = reader.readByte();
    return RiskLevel.values[index.clamp(0, RiskLevel.values.length - 1)];
  }

  @override
  void write(BinaryWriter writer, RiskLevel obj) {
    writer.writeByte(obj.index);
  }
}

class ReportAdapter extends TypeAdapter<Report> {
  @override
  final int typeId = 1;

  @override
  Report read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Report(
      id: fields[0] as String,
      title: fields[1] as String,
      summary: fields[2] as String,
      riskLevel: fields[3] as RiskLevel,
      imageUrls: (fields[4] as List).cast<String>(),
      date: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
      fullAnalysis: fields[6] as String?,
      userNote: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Report obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.riskLevel)
      ..writeByte(4)
      ..write(obj.imageUrls)
      ..writeByte(5)
      ..write(obj.date.millisecondsSinceEpoch)
      ..writeByte(6)
      ..write(obj.fullAnalysis)
      ..writeByte(7)
      ..write(obj.userNote);
  }
}
