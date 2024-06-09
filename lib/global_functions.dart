import 'dart:developer' as dev;
import 'dart:math';

Future<List<int>> generate6UniqueNumbers({
  required int setLength,
  required int maxValueNumber,
}) async {
  Random random = Random();
  Set<int> uniqueNumbers = {};

  // Generate numbers until we have 6 unique ones
  while (uniqueNumbers.length < setLength) {
    int number = random.nextInt(maxValueNumber) + 1; // Generate a number between 1 and 50
    uniqueNumbers.add(number); // Add to the set (duplicates are automatically handled)
  }
  dev.log(uniqueNumbers.toString());

  return uniqueNumbers.toList(); // Convert the set to a list and return
}

class IsolateParam {
  final List<int> numberDrawn;
  final int setLength;
  final int maxValueNumber;
  final int numSetPerDraw;

  IsolateParam({required this.numberDrawn, required this.setLength, required this.maxValueNumber, required this.numSetPerDraw});
}

Future<List<int>?> computeSum(IsolateParam isolateParam) async {
  List<int> winningNumber;
  for (int i = 0; i < isolateParam.numSetPerDraw; i++) {
    winningNumber = await generate6UniqueNumbers(maxValueNumber: isolateParam.maxValueNumber, setLength: isolateParam.setLength);
    if (compareLists(winningNumber, isolateParam.numberDrawn)) {
      return winningNumber;
    }
  }
  return null;
}

bool compareLists(List<int> list1, List<int> list2) {
  return Set<int>.from(list1).containsAll(list2) && Set<int>.from(list2).containsAll(list1);
}
