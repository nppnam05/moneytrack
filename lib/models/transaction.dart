class Transaction {
  int id;
  int user_id;
  int category_id;
  String type;
  double amount;
  String description;
  int transaction_date;
  int created_at;
  Transaction(this.id, this.user_id, this.category_id, this.type, this.amount, this.description, this.transaction_date, this.created_at);
}