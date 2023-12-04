import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ayurvedic_terms.dart';

class MessagesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;

  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {}
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          bool isUserMessage = widget.messages[index]['isUserMessage'];
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Align(
              alignment:
                  isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: w * 2 / 3,
                  minWidth: 0,
                ),
                child: Column(
                  crossAxisAlignment: isUserMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isUserMessage ? 20 : 0),
                          topRight: const Radius.circular(20),
                          bottomLeft: const Radius.circular(20),
                          bottomRight: Radius.circular(isUserMessage ? 0 : 20),
                        ),
                        color: isUserMessage
                            ? const Color.fromARGB(255, 35, 173, 250)
                                .withOpacity(0.9)
                            : const Color.fromARGB(255, 35, 185, 50)
                                .withOpacity(0.9),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildMessageText(
                              widget.messages[index]['message'].text.text[0]),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    if (widget.messages[index]['timestamp'] != null)
                      Padding(
                        padding: EdgeInsets.only(
                          top: 4,
                          right: isUserMessage ? 8 : 0,
                          left: isUserMessage ? 0 : 8,
                          bottom: 4,
                        ),
                        child: Align(
                          alignment: isUserMessage
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: Text(
                            _formatTimestamp(
                                widget.messages[index]['timestamp']),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMessageText(String message) {
    RegExp ayurvedicTermRegex = RegExp(
      r'\b(Pratishyaya|Sannipata Jvara|Pinasa|Jvara|Anantavata|Madhumeha|Raktagata Vata|Anidra|Amavata|Arbuda|Smritibhramsha|Asthi-Majja Gata Vata|Tamaka Shwasa|Amlapitta|Vrikka Daurbalya|Vicharchika|Sidhma Kushtam|Visuchika|Rajayakshma|Kampavata|Yakritpleeha Sotha|Vatarakta|Yoni Dosha|Rajaswala Dosha|Granthsada Yonivyapad|Garbhasayagata Prameha|Rajaswala Anta|Asthi-Majja Kshaya|Vata|Pitta|Kapha)\b',
      caseSensitive: false,
    );

    List<TextSpan> textSpans = [];
    Iterable<Match> matches = ayurvedicTermRegex.allMatches(message);

    int lastMatchEnd = 0;
    for (Match match in matches) {
      textSpans.add(TextSpan(
        text: message.substring(lastMatchEnd, match.start),
        style: const TextStyle(
          color: Colors.white,
        ),
      ));

      String term = match.group(0)!;
      textSpans.add(
        TextSpan(
          text: term,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showAyurvedicTermDialog(context, term);
            },
        ),
      );

      lastMatchEnd = match.end;
    }

    textSpans.add(TextSpan(
      text: message.substring(lastMatchEnd),
      style: const TextStyle(
        color: Colors.white,
      ),
    ));

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    String period = timestamp.hour < 12 ? 'am' : 'pm';
    int hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;

    return '$hour:${timestamp.minute < 10 ? '0' : ''}${timestamp.minute} $period';
  }

  void showAyurvedicTermDialog(BuildContext context, String term) {
    String details = termDetails[term] ?? 'Details not available.';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ayurvedic Term: $term',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.blue,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  details,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Close'),
            ),
          ],
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant MessagesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
