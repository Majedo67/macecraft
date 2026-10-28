import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaceCraft());

class MaceCraft extends StatelessWidget {
  const MaceCraft({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GamePage(),
      );
}

const blocks = <String, Color>{
  'Grass': Color(0xFF4CAF50),
  'Dirt': Color(0xFF8D6142),
  'Stone': Color(0xFF9E9E9E),
  'Wood': Color(0xFFB8864D),
  'Brick': Color(0xFFB34033),
};

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const cols = 10, rows = 16;
  final List<List<String?>> grid = List.generate(
      rows,
      (r) => List<String?>.filled(
          cols, r == 12 ? 'Grass' : (r > 12 ? 'Dirt' : null)));
  bool breaking = false;
  String selected = 'Stone';

  void tap(int r, int c) => setState(() {
        grid[r][c] = breaking ? null : selected;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: LayoutBuilder(builder: (context, box) {
              final s = min(box.maxWidth / cols, box.maxHeight / rows);
              return Center(
                child: SizedBox(
                  width: s * cols,
                  height: s * rows,
                  child: Column(children: [
                    for (int r = 0; r < rows; r++)
                      Expanded(
                        child: Row(children: [
                          for (int c = 0; c < cols; c++)
                            Expanded(
                              child: GestureDetector(
                                onTap: () => tap(r, c),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: grid[r][c] == null
                                        ? Colors.transparent
                                        : blocks[grid[r][c]],
                                    border: Border.all(
                                        color: Colors.black12, width: 0.5),
                                  ),
                                ),
                              ),
                            ),
                        ]),
                      ),
                  ]),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 6,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => breaking = !breaking),
                  child: Text(breaking ? 'Break' : 'Place'),
                ),
                for (final name in blocks.keys)
                  ChoiceChip(
                    label: Text(name),
                    selected: selected == name,
                    onSelected: (_) => setState(() {
                      selected = name;
                      breaking = false;
                    }),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
