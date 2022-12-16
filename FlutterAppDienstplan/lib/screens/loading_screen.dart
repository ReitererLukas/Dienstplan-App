import 'package:dienstplan/components/app_bar.dart';
import 'package:flutter/material.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DienstplanAppBar(showSettings: false, stateOfScreen: this, arrowBack: false),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
