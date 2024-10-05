import 'dart:async';

class MockOBDService {
  // A map to hold fault codes categorized by affected parts
  final Map<String, List<String>> faultCodeMap = {
    'Engine': ['P0300', 'P0420', 'P0455'], // Fault codes related to the engine
    'Body': ['B0010', 'B0020', 'B0030'],   // Fault codes related to the body
    'Chassis': ['C0001', 'C0002', 'C0003'], // Fault codes related to the chassis
    'Network': ['U0001', 'U0002', 'U0003'], // Fault codes related to the network
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

  int currentFaultIndex = 0; // Index to track the current fault code
  String currentAffectedPart = 'Engine'; // Default affected part
  Timer? _timer; // Timer for periodic updates

void startMockMode(Function(String, String) onFaultCodeChange) {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        // Update the affected part based on the current index
        List<String> parts = faultCodeMap.keys.toList();
        currentAffectedPart = parts[currentFaultIndex % parts.length];

        // Get the corresponding fault codes for the affected part
        List<String> faultCodes = faultCodeMap[currentAffectedPart]!;

        // Loop through fault codes
        String currentFaultCode = faultCodes[currentFaultIndex % faultCodes.length];
        String faultDescription = faultCodeDescriptions[currentFaultCode] ?? 'unknown issue'; // Ensure you have this map defined

        currentFaultIndex++;

        // Notify the change
        onFaultCodeChange(currentAffectedPart, '$currentFaultCode - $faultDescription');
    });
}
  // Method to stop the mock mode
  void stopMockMode() {
    _timer?.cancel(); // Cancel the timer if it's running
  }
}
