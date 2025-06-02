class BoundingBox {
  final double x, y, w, h;

  BoundingBox({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  factory BoundingBox.fromRawJson(
    List<dynamic> bbox,
    int imgWidth,
    int imgHeight,
  ) {
    double xmin = bbox[0], ymin = bbox[1], xmax = bbox[2], ymax = bbox[3];
    return BoundingBox(
      x: xmin / imgWidth,
      y: ymin / imgHeight,
      w: (xmax - ymin) / imgWidth,
      h: (ymax - ymin) / imgHeight,
    );
  }
}
