import 'package:pedometer/pedometer.dart';

class PedometerService {
  Stream<StepCount>? stepCountStream;

  PedometerService() {
    stepCountStream = Pedometer.stepCountStream;
  }
}