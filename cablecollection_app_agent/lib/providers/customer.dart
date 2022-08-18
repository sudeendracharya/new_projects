class Customer {
  final String cuId;
  final String id;
  final String name;
  final String email;
  final String address;
  final int mobile;
  final String aadharnumber;
  final String packages;
  final String packageAmount;
  final String status;
  final String node;
  final String due;
  final String advance;
  final String stbMaterial;
  final String area;
  final String tv;
  final String subscriptionEndDate;

  final String stbId;
  final String smartCardNumber;

  static var areaName;
  static var customerId;
  static var areaNode;

  Customer({
    this.cuId,
    this.id,
    this.name,
    this.email,
    this.address,
    this.mobile,
    this.aadharnumber,
    this.packages,
    this.status,
    this.node,
    this.due,
    this.advance,
    this.stbMaterial,
    this.area,
    this.tv,
    this.subscriptionEndDate,
    this.stbId,
    this.packageAmount,
    this.smartCardNumber,
  });
}
