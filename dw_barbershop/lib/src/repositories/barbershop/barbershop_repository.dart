import 'package:dw_barbershop/src/models/barbershop_model.dart';

abstract class BarbershopRepository {
  Future<BarbershopModel> getById(int id);
  Future<List<BarbershopModel>> getAll();
  Future<BarbershopModel> save(BarbershopModel barbershop);
}
