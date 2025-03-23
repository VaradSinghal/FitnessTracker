import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerService {
  Stream<StepCount>? stepCountStream;

  PedometerService() {
    _initPedometer();
  }

  Future<void> _initPedometer() async {
    var status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      stepCountStream = Pedometer.stepCountStream;
      stepCountStream?.listen((event) {
        print('Step count updated: ${event.steps}');
      }).onError((error) {
        print('Pedometer error: $error');
      });
    } else {
      print('Activity recognition permission denied');
    }
  }
}