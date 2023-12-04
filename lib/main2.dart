import 'package:flutter/material.dart';
import 'package:ayurveda_chatbot/splash.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:ayurveda_chatbot/messages.dart';

import 'login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayurveda Bot',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) {
      dialogFlowtter = instance;
      sendInitialGreeting();
    });
  }

  void sendInitialGreeting() async {
    String initialGreeting =
        "Hello! I am AyurvedaBot. How can I help you today?";
    setState(() {
      addMessage(Message(text: DialogText(text: [initialGreeting])), false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
          },
        ),
        title: const Text(
          'Ayurveda Bot',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(60, 19, 24, 33),
                Color.fromARGB(200, 0, 6, 9),
              ],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/bgdoodle1.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(60, 33, 41, 58),
                      Color.fromARGB(200, 5, 16, 21),
                    ],
                  ),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${getCurrentDay()}, ${getCurrentMonth()} ${getCurrentDate()}, ${getCurrentYear()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MessagesScreen(messages: messages),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(60, 40, 50, 70).withOpacity(0.8),
                      const Color.fromARGB(200, 10, 30, 40).withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                              fontFamily: 'Poppins',
                            ),
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.newline,
                          maxLines: null,
                          onSubmitted: (text) {
                            sendMessage(text);
                            _controller.clear();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        clearMessages();
                      },
                      icon: const Icon(Icons.clear),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: const Icon(Icons.send_rounded),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return now.day.toString();
  }

  void sendMessage(String text) async {
    if (text.isEmpty) {
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
        addMessage(Message(text: DialogText(text: const ['Typing...'])), false);
      });

      await Future.delayed(const Duration(seconds: 1));

      text = text.toLowerCase();

      // Handle specific queries
      if (text.contains('hello') || text.contains('hi')) {
        String name = _extractNameFromGreeting(text);
        String response;
        if (name.isNotEmpty) {
          response = "Hello $name! How can I assist you today?";
        } else {
          response = "Hello! How can I help you today?";
        }
        setState(() {
          messages.last['message'] =
              Message(text: DialogText(text: [response]));
        });
      } else if (text.contains('thanks') || text.contains('thank you')) {
        String name = _extractNameFromMessage(text);
        String response;
        if (name.isNotEmpty) {
          response =
              "You're welcome, $name! If you have more questions, feel free to ask.";
        } else {
          response =
              "You're welcome! If you have more questions, feel free to ask.";
        }
        setState(() {
          messages.last['message'] =
              Message(text: DialogText(text: [response]));
        });
      } else if (text.contains('what time is it')) {
        String response = 'The current time is ${getCurrentTime()}';
        setState(() {
          messages.last['message'] =
              Message(text: DialogText(text: [response]));
        });
      } else if (text.contains('what day is it')) {
        String response = 'Today is ${getCurrentDay()}';
        setState(() {
          messages.last['message'] =
              Message(text: DialogText(text: [response]));
        });
      } else if (text.contains('what month is it')) {
        String response = 'The current month is ${getCurrentMonth()}';
        setState(() {
          messages.last['message'] =
              Message(text: DialogText(text: [response]));
        });
      } else if (text.contains('what year is it')) {
        String response = 'The current year is ${getCurrentYear()}';
        setState(() {
          messages.last['message'] =
              Message(text: DialogText(text: [response]));
        });
      } else {
        DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)),
        );
        if (response.message != null) {
          setState(() {
            messages.last['message'] = response.message!;
          });
        }
      }
    }
  }

  void clearMessages() {
    final bool hasMessages = messages.isNotEmpty;

    if (hasMessages) {
      _showConfirmationDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: _buildSnackbarContent('No messages to clear'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 70, left: 10, right: 10),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 4,
        ),
      );
    }
  }

  Widget _buildSnackbarContent(String message) {
    return Builder(
      builder: (BuildContext snackBarContext) => Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirm',
            style: TextStyle(
              color: Colors.blue,
              fontFamily: 'Poppins',
            ),
          ),
          content: const Text(
            'Are you sure you want to clear all the messages?',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  messages.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: _buildSnackbarContent('Messages cleared'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    margin:
                        const EdgeInsets.only(bottom: 70, left: 10, right: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.9),
                    elevation: 4,
                  ),
                );
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    return '${_formatHour(now.hour)}:${_formatMinute(now.minute)} ${_getPeriod(now.hour)}';
  }

  String getCurrentDay() {
    DateTime now = DateTime.now();
    return _getDayOfWeek(now.weekday);
  }

  String getCurrentMonth() {
    DateTime now = DateTime.now();
    return _getMonth(now.month);
  }

  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }

  String _extractNameFromGreeting(String greeting) {
    if (greeting.contains('i am') || greeting.contains('my name is')) {
      List<String> words = greeting.split(' ');
      int indexOfAm = words.indexOf('am');
      int indexOfIs = words.indexOf('is');
      int indexOfName = words.indexOf('name');
      int nameIndex = indexOfAm > 0
          ? indexOfAm + 1
          : indexOfIs > 0
              ? indexOfIs + 1
              : indexOfName > 0
                  ? indexOfName + 1
                  : -1;

      if (nameIndex > 0 && nameIndex < words.length) {
        return words[nameIndex];
      }
    }
    return '';
  }

  String _extractNameFromMessage(String message) {
    if (message.contains('my name is')) {
      List<String> words = message.split(' ');
      int indexOfIs = words.indexOf('is');
      int indexOfName = words.indexOf('name');
      int nameIndex = indexOfIs > 0
          ? indexOfIs + 1
          : indexOfName > 0
              ? indexOfName + 1
              : -1;

      if (nameIndex > 0 && nameIndex < words.length) {
        return words[nameIndex];
      }
    }
    return '';
  }

  String _formatHour(int hour) {
    return hour % 12 == 0 ? '12' : (hour % 12).toString().padLeft(2, '0');
  }

  String _formatMinute(int minute) {
    return minute.toString().padLeft(2, '0');
  }

  String _getPeriod(int hour) {
    return hour < 12 ? 'AM' : 'PM';
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _getMonth(int month) {
    switch (month) {
      case DateTime.january:
        return 'January';
      case DateTime.february:
        return 'February';
      case DateTime.march:
        return 'March';
      case DateTime.april:
        return 'April';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'June';
      case DateTime.july:
        return 'July';
      case DateTime.august:
        return 'August';
      case DateTime.september:
        return 'September';
      case DateTime.october:
        return 'October';
      case DateTime.november:
        return 'November';
      case DateTime.december:
        return 'December';
      default:
        return '';
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
      'timestamp': DateTime.now(),
    });
  }
}
