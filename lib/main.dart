import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String selectedMood = "Motivational";
  String currentQuote = "Click below to get inspired!";
  Color _bgColor = const Color(0xFFF4C2C2);
  List<String> favoriteQuotes = [];

  final Map<String, List<String>> categorizedQuotes = {
    "Motivational": [
      "The best way to predict the future is to create it.",
      "Believe you can and you're halfway there.",
      "Don’t watch the clock; do what it does. Keep going.",
      "The only way to do great work is to love what you do.",
      "Your time is limited, don't waste it living someone else's life.",
      "It does not matter how slowly you go as long as you do not stop.",
      "You miss 100% of the shots you don't take.",
      "What lies behind you and what lies in front of you, pales in comparison to what lies inside of you.",
      "The only limit to our realization of tomorrow will be our doubts of today.",
      "Happiness depends upon ourselves.",
      "You only live once, but if you do it right, once is enough.",
      "Work hard in silence, let your success be your noise.",
      "The only way to do great work is to love what you do.",
    ],
    "Love": [
      "Love is not about how many days, months, or years you've been together. Love is about how much you love each other every single day.",
      "To love and be loved is to feel the sun from both sides.",
      "You don't love someone for their looks, or their clothes, or for their fancy car, but because they sing a song only you can hear.",
      "If I know what love is, it is because of you.",
      "Love is composed of a single soul inhabiting two bodies.",
      "The best thing to hold onto in life is each other.",
      "Love is when you meet someone who tells you something new about yourself.",
      "Love is not finding someone to live with; it's finding someone you can't live without.",
    ],
    "Funny": [
      "I'm not saying I'm lazy, but I plan to have my tombstone say, 'Do Not Disturb.",
      "I used to think I was indecisive, but now I'm not so sure.",
      "My bed is a magical place where I suddenly remember everything I had to do.",
      "I'm not arguing, I'm just explaining why I'm right.",
      "If you can't remember my name, just say 'Chocolate' and I'll turn around.",
      "I'm not clumsy, the floor just hates me, the table and chairs are bullies and the walls get in my way.",
      "I'm on a seafood diet. I see food and I eat it.",
      "I told my wife she was drawing her eyebrows too high. She seemed surprised.",
      "Before you criticize someone, walk a mile in their shoes. That way, when you criticize them, you're a mile away and you have their shoes.",
      "A balanced diet means a cupcake in each hand.",
      "I'm not sure how many problems I have because math is one of them.",
    ],
    "Life & Wisdom": [
      "The purpose of our lives is to be happy.",
      "Life is what happens when you're busy making other plans.",
      "Get busy living or get busy dying.",
      "The greatest glory in living lies not in never falling, but in rising every time we fall.",
      "In three words I can sum up everything I've learned about life: it goes on.",
      "Life is either a daring adventure or nothing at all.",
      "To live is the rarest thing in the world. Most people exist, that is all.",
      "Never let the fear of striking out keep you from playing the game.",
      "The best time to plant a tree was 20 years ago. The second best time is now.",
      "It is not the years in your life but the life in your years that counts.",
    ],
    "Selfcare": [
      "Almost everything will work again if you unplug it for a few minutes, including you",
      "You can’t pour from an empty cup. Take care of yourself first.",
      "Self-care is not a luxury, it’s a necessity.",
      "Do something today that your future self will thank you for.",
      "Loving yourself isn’t vanity. It’s sanity.",
      "Rest and self-care are so important. When you take time to replenish your spirit, it allows you to serve others from the overflow.",
      "You owe yourself the love that you so freely give to others.",
      "Take time to do what makes your soul happy.",
      "Be kind to yourself. You are doing the best you can.",
      "Caring for myself is not self-indulgence, it is self-preservation.",
    ],
  };

  void showNewQuote() {
    final quotesList = categorizedQuotes[selectedMood]!;
    setState(() {
      currentQuote = (quotesList..shuffle()).first;
    });
  }

  void changeColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick Background Color"),
          content: BlockPicker(
            pickerColor: _bgColor,
            onColorChanged: (color) {
              setState(() {
                _bgColor = color;
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text("DONE"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void playTapSound() {
    _audioPlayer.play(AssetSource('tap.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _bgColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Quotes App"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () async {
                final removedQuote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesPage(favoriteQuotes: favoriteQuotes),
                  ),
                );

                if (removedQuote != null) {
                  setState(() {
                    favoriteQuotes.remove(removedQuote);
                  });
                }
              },
            ),
            IconButton(icon: const Icon(Icons.color_lens), onPressed: changeColor),
          ],
        ),
        body: Stack(
          children: [
            ...List.generate(12, (index) {
              return Positioned(
                top: Random().nextDouble() * MediaQuery.of(context).size.height,
                left: Random().nextDouble() * MediaQuery.of(context).size.width,
                child: Transform.rotate(
                  angle: Random().nextDouble() * 2 * pi,
                  child: const Icon(Icons.bookmark, color: Colors.redAccent, size: 20),
                ),
              );
            }),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: const Color.fromARGB(255, 44, 171, 180),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              child: DropdownButton<String>(
                                value: selectedMood,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMood = newValue!;
                                  });
                                },
                                items: categorizedQuotes.keys.map<DropdownMenuItem<String>>((String mood) {
                                  return DropdownMenuItem<String>(
                                    value: mood,
                                    child: Text(mood, style: GoogleFonts.poppins(fontSize: 18)),
                                  );
                                }).toList(),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              child: Text(
                                currentQuote,
                                key: ValueKey<String>(currentQuote),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    favoriteQuotes.contains(currentQuote) ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    playTapSound();
                                    setState(() {
                                      if (favoriteQuotes.contains(currentQuote)) {
                                        favoriteQuotes.remove(currentQuote);
                                      } else {
                                        favoriteQuotes.add(currentQuote);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    showNewQuote();
                                    playTapSound();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.tealAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    "New Quote",
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<String> favoriteQuotes;

  const FavoritesPage({super.key, required this.favoriteQuotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Quotes"),
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
      ),
      body: favoriteQuotes.isEmpty
          ? Center(
              child: Text(
                "No favorites yet!",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: favoriteQuotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.pink.shade50,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        favoriteQuotes[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          Navigator.pop(context, favoriteQuotes[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
