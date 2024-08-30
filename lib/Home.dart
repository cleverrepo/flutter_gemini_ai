import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gemini_ai/theme.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];
  var apiKey = 'AIzaSyAJU42cRWGFInHNnQEjtXtB-u6dLBuRHoM';
  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add("You: $message");
    });
    _controller.clear();

    try {
      // Create an instance of GenerativeModel
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final prompt = message;

      final response = await model.generateContent([Content.text(prompt)]);

      setState(() {
        _messages.add("Gemini: ${response.text}");
      });

      _scrollToBottom();
    } catch (e) {
      print('Exception: $e');
      setState(() {
        _messages.add("AI: Failed to connect");
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, ThemeProvider value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: value.isToggle
                    ? const Icon(Icons.sunny)
                    : const Icon(Icons.nightlight_outlined),
                onPressed: () {
                  value.changeTheme();
                },
              ),
            ],
            centerTitle: true,
            title: const Text("AI Chat app"),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: _messages[index].startsWith("You")
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _messages[index].startsWith("You")
                                ? Colors.blue
                                : Colors.green,
                            borderRadius: _messages[index].startsWith("You")
                                ? const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                  )
                                : const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                          ),
                          child: Text(
                            _messages[index],
                            style: TextStyle(
                                color: value.isToggle
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Enter your message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _sendMessage(_controller.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
