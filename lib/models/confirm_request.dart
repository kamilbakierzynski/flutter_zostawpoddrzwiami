class ConfirmRequest {
  String makerUid;
  String takerUid;
  String orderId;
  bool received;

  ConfirmRequest({this.orderId, this.makerUid, this.received, this.takerUid});

}