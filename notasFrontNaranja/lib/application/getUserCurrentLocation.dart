import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/location.dart';

abstract class GetUserLocation {
  Future<Either<MyError, Location>> getCurrentLocation();
}

class GetUserCurrentLocationService implements service<void, Location> {
  GetUserLocation location;

  GetUserCurrentLocationService({
    required this.location,
  });

  @override
  Future<Either<MyError, Location>> execute(void params) async {
    Either<MyError, Location> getLocationResponse =
        await location.getCurrentLocation();
    if (getLocationResponse.isLeft) {
      return Left(getLocationResponse.left);
    }
    return Right(getLocationResponse.right);
  }
  
}
