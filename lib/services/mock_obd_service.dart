import 'dart:async';
import 'dart:math';

class MockOBDService {
  // A map to hold fault codes categorized by affected parts
  final Map<String, List<String>> faultCodeMap = {
    'Engine': ['P0300', 'P0420', 'P0455'],
    'Body': ['B0010', 'B0020', 'B0030'],
    'Chassis': ['C0001', 'C0002', 'C0003'],
    'Network': ['U0001', 'U0002', 'U0003'],
  };

  // A map to hold descriptions for the fault codes
  final Map<String, String> faultCodeDescriptions = {
    'P0300': 'random/multiple cylinder misfire detected',
    'P0420': 'catalytic converter efficiency below threshold',
    'P0455': 'evaporative emission control system leak detected (large)',
    'B0010': 'driver\'s seat belt buckle switch failure',
    'B0020': 'passenger\'s seat belt buckle switch failure',
    'B0030': 'rear passenger\'s seat belt buckle switch failure',
    'C0001': 'trouble with the ABS system',
    'C0002': 'trouble with the traction control system',
    'C0003': 'trouble with the electronic stability control system',
    'U0001': 'high-speed CAN communication bus fault',
    'U0002': 'low-speed CAN communication bus fault',
    'U0003': 'communication error in vehicle network',
  };

  List<String> allFaultCodes = []; // List to hold all fault codes
  Random _random = Random(); // Random number generator
  Timer? _timer; // Timer for periodic updates

  MockOBDService() {
    // Populate the list of all fault codes
    allFaultCodes = faultCodeDescriptions.keys.toList();
  }

  void startMockMode(Function(List<Map<String, String>>) onFaultCodesChange) {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      // Generate between 1 to 3 fault codes
      int numberOfFaults = _random.nextInt(3) + 1;
      List<Map<String, String>> faultCodes = [];

      for (int i = 0; i < numberOfFaults; i++) {
        // Select a random fault code from all available codes
        String currentFaultCode = allFaultCodes[_random.nextInt(allFaultCodes.length)];
        String faultDescription = faultCodeDescriptions[currentFaultCode] ?? 'unknown issue';

        // Determine the affected part for the current fault code based on its key
        String affectedPart = faultCodeMap.entries
            .firstWhere((entry) => entry.value.contains(currentFaultCode))
            .key;

        // Add the fault code information to the list
        faultCodes.add({
          'affectedPart': affectedPart,
          'faultCode': currentFaultCode,
          'description': faultDescription,
        });
      }

      // Notify the change
      onFaultCodesChange(faultCodes);
    });
  }

  // Method to stop the mock mode
  void stopMockMode() {
    _timer?.cancel(); // Cancel the timer if it's running
  }
}