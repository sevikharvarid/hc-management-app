library general_helper;

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/shared/widgets/location_service/bloc/location_service_event.dart';
import 'package:hc_management_app/shared/widgets/location_service/bloc/location_service_state.dart';
import 'package:rxdart/rxdart.dart';

class LocationServiceBloc
    extends Bloc<LocationServiceEvent, LocationServiceState> {
  late StreamSubscription subscription;
  late StreamSubscription<ServiceStatus> serviceStatusStream;
  late bool isLocationEnabled = false;
  late bool isConnected = true;
  late bool isChanges = false;

  late bool isLocationMessageShown = false;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  LocationServiceBloc() : super(LocationServiceLoading()) {
    on<LocationServiceStarted>(initLocationService);
  }

  Future<void> initLocationService(
    LocationServiceStarted event,
    Emitter<LocationServiceState> emit,
  ) async {
    // emit(LocationServiceInitial());
    serviceStatusStream = getServiceStatusStreamWithCurrentStatus()
        .listen((ServiceStatus status) {
      print(status);
      if (status == ServiceStatus.disabled) {
        isConnected = false;
        // isChanges = true;
        add(LocationServiceStarted());
        return;
      }
      if (status == ServiceStatus.enabled) {
        isConnected = true;
        // isChanges = isChanges ? true : false;
        add(LocationServiceStarted());
        return;
      }
    });

    if (!isConnected) {
      emit(LocationServiceUnavailable());
      return;
    }

    if (isConnected) {
      // isChanges = false;
      emit(LocationServiceAvailable());
      return;
    }
  }

  Stream<ServiceStatus> getServiceStatusStreamWithCurrentStatus() async* {
    yield await Geolocator.isLocationServiceEnabled().then(
        (value) => value ? ServiceStatus.enabled : ServiceStatus.disabled);
    yield* Geolocator.getServiceStatusStream();
  }

  // subscription = LocationService.onLocationServiceChanged
  //     .listen((LocationServiceResult LocationServiceResult) {
  //   if (LocationServiceResult == LocationServiceResult.none) {
  //     isConnected = false;
  //     isChanges = true;
  //     add(LocationServiceStarted());
  //     return;
  //   } else if (LocationServiceResult == LocationServiceResult.wifi) {
  //     isConnected = true;
  //     isChanges = isChanges ? true : false;
  //     add(LocationServiceStarted());
  //     return;
  //   } else if (LocationServiceResult == LocationServiceResult.mobile) {
  //     isConnected = true;
  //     isChanges = isChanges ? true : false;
  //     add(LocationServiceStarted());
  //     return;
  //   }
  // });

  // Future<void> _checkLocation(
  //   LocationServiceStarted event,
  //   Emitter<LocationServiceState> emit,
  // ) async {
  //   try {
  //     isLocationEnabled = await Permission.location.isGranted;
  //   } on Exception catch (e) {
  //     log('Error checking location: $e');
  //   }

  //   if (!isLocationEnabled) {
  //     emit(LocationServiceUnavailable());
  //   } else {
  //     emit(LocationServiceAvailable());
  //   }
  // }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
