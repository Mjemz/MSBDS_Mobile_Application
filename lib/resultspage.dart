import 'package:flutter/material.dart';
class ResultDisplayScreen extends StatelessWidget {
  final Map<String, dynamic> analysisResults;
  const ResultDisplayScreen(this.analysisResults, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Text('Analysis Results:', style: Theme.of(context).textTheme.titleLarge),
            ...analysisResults.entries.map((e) => ListTile(
              title: Text(e.key),
              subtitle: Text(e.value.toString()),
            )),
          ],
        ),
      ),
    );
  }
}