import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../global_functions.dart';

class TotoSimulatorMainPage extends StatefulWidget {
  const TotoSimulatorMainPage({super.key});

  @override
  State<TotoSimulatorMainPage> createState() => _TotoSimulatorMainPageState();
}

class _TotoSimulatorMainPageState extends State<TotoSimulatorMainPage> {
  ValueNotifier<List<int>> numberDrawnNotifier = ValueNotifier([]);
  List<int> winningNumber = [];
  ValueNotifier<int> buildCountNotifier = ValueNotifier(0);
  int setLength = 6;
  int numSetPerDraw = 10;
  int maxValueNumber = 50;

  bool hasWon = false;
  bool isLoading = false;
  late TextEditingController numSetPerDrawController;
  late TextEditingController maxNumberValuewController;
  late TextEditingController setLengthController;

  Future<void> generate10SetOf6UniqueNumbersAndCompare() async {
    List<int>? res = await compute(
      computeSum,
      IsolateParam(numberDrawn: numberDrawnNotifier.value, setLength: setLength, maxValueNumber: maxValueNumber, numSetPerDraw: numSetPerDraw),
    );

    if (res != null) {
      setState(() {
        winningNumber = res;
        winningNumber.sort();
        numberDrawnNotifier.value.sort();
        hasWon = true;
      });
    }

    return;
  }

  void reset() {
    hasWon = false;
    numberDrawnNotifier.value = [];
    winningNumber = [];
    buildCountNotifier.value = 0;
  }

  @override
  void initState() {
    numSetPerDrawController = TextEditingController(text: numSetPerDraw.toString());
    maxNumberValuewController = TextEditingController(text: maxValueNumber.toString());
    setLengthController = TextEditingController(text: setLength.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const SizedBox(
          width: double.infinity,
          child: Text(
            'Lottery Simulator',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 24,
            ),
            if (!isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: numSetPerDrawController,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Number of set per draw'),
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) {
                          numSetPerDraw = int.tryParse(value) ?? 1;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: maxNumberValuewController,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Max Number Value'),
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) {
                          maxValueNumber = int.tryParse(value) ?? 1;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: setLengthController,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Set Length'),
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            setLength = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 36,
            ),
            Column(
              children: [
                const Text(
                  'Set Drawn:',
                  style: TextStyle(fontSize: 24),
                ),
                ValueListenableBuilder(
                    valueListenable: numberDrawnNotifier,
                    builder: (_, numberDrawn, __) {
                      if (numberDrawn.isEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...List.generate(
                              setLength,
                              (index) {
                                return const Text('**');
                              },
                            )
                          ],
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...numberDrawn.map(
                            (e) {
                              return Text(
                                e.toString(),
                                style: const TextStyle(fontSize: 24),
                              );
                            },
                          )
                        ],
                      );
                    }),
              ],
            ),
            const SizedBox(
              height: 36,
            ),
            if (winningNumber.isNotEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Winning Number:',
                    style: TextStyle(fontSize: 24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...winningNumber.map(
                        (e) {
                          return Text(
                            e.toString(),
                            style: const TextStyle(fontSize: 24),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            const SizedBox(
              height: 36,
            ),
            Column(
              children: [
                const Text(
                  'Draw Count:',
                  style: TextStyle(fontSize: 24),
                ),
                ValueListenableBuilder(
                    valueListenable: buildCountNotifier,
                    builder: (_, buildCount, __) {
                      return Text(
                        buildCount.toString(),
                        style: const TextStyle(fontSize: 24),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () async {
                if (isLoading) {
                  return;
                }
                setState(() {
                  isLoading = true;
                });
                reset();
                while (!hasWon) {
                  numberDrawnNotifier.value = await generate6UniqueNumbers(maxValueNumber: maxValueNumber, setLength: setLength);
                  await generate10SetOf6UniqueNumbersAndCompare();

                  buildCountNotifier.value++;
                }
                setState(() {
                  isLoading = false;
                });
              },
              child: const Text('Start Simulation'),
            ),
    );
  }
}
