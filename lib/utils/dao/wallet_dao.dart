import 'package:floor/floor.dart';
import '../../models/wallet.dart';

@dao
abstract class WalletDao {
  @Query('SELECT * FROM wallets')
  Future<List<Wallet>> getAllWallets();

  @Query('SELECT * FROM wallets WHERE id = :id')
  Future<Wallet?> getWalletById(int id);

  @Query('SELECT * FROM wallets WHERE userId = :userId')
  Future<List<Wallet>> getWalletsByUserId(int userId);

  @insert
  Future<void> insertWallet(Wallet wallet);

  @update
  Future<void> updateWallet(Wallet wallet);

  @delete
  Future<void> deleteWallet(Wallet wallet);
}