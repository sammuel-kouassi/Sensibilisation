class ImageModel {
  final int? id;
  final int? serverId;
  final int seanceId;
  final String url;
  final String? legende;
  final DateTime date;
  final bool isSynced;

  const ImageModel({
    this.id,
    this.serverId,
    required this.seanceId,
    required this.url,
    this.legende,
    required this.date,
    this.isSynced = false,
  });

  ImageModel copyWith({
    int? id,
    int? serverId,
    int? seanceId,
    String? url,
    String? legende,
    DateTime? date,
    bool? isSynced,
  }) {
    return ImageModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      seanceId: seanceId ?? this.seanceId,
      url: url ?? this.url,
      legende: legende ?? this.legende,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}