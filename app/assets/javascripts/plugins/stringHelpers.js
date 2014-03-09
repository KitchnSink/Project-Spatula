String.prototype.formatMoney = function () {
  var n = Number(this);
  return '$' + n.toFixed(2);
};

String.prototype.toDateTime = function (unit) {
  date = Date();
};
