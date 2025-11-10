import 'dart:math';
import 'package:flutter/material.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LockScreen()));

class LockScreen extends StatefulWidget {
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final passCtrl = TextEditingController();
  final String password = "1234";
  bool _wrong = false;

  void unlock() {
    if (passCtrl.text.trim() == password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NotesApp()),
      );
    } else {
      setState(() => _wrong = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.deepPurple),
              SizedBox(height: 15),
              Text("Locked Notes ",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              SizedBox(height: 20),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  errorText: _wrong ? "Incorrect Password " : null,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: unlock,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: Size(double.infinity, 45)),
                child: Text("Unlock",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotesApp extends StatefulWidget {
  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  final noteCtrl = TextEditingController();
  final rnd = Random();
  final List<Map<String, dynamic>> notes = [];

  final colors = [
    Colors.pinkAccent.shade100,
    Colors.lightBlueAccent.shade100,
    Colors.limeAccent.shade100,
    Colors.amberAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.deepPurpleAccent.shade100,
    Colors.orangeAccent.shade100,
  ];

  Color selectedColor = Colors.pinkAccent.shade100;

  void addNote() {
    if (noteCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Write something before adding ")),
      );
      return;
    }
    final now = DateTime.now();
    setState(() {
      notes.add({
        "text": noteCtrl.text.trim(),
        "time":
            "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}",
        "color": selectedColor,
        "reminder": null,
        "fav": false,
      });
    });
    noteCtrl.clear();
  }

  void deleteNote(int i) => setState(() => notes.removeAt(i));

  void toggleFav(int i) {
    setState(() {
      notes[i]["fav"] = !notes[i]["fav"];
    });
  }

  void addReminder(int i) {
    final now = DateTime.now();
    final reminder = DateTime(now.year, now.month + 1, now.day);
    setState(() {
      notes[i]["reminder"] =
          "${reminder.day}/${reminder.month}/${reminder.year}";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reminder added for next month")),
    );
  }

  void editNoteDialog(int i) {
    final editCtrl = TextEditingController(text: notes[i]["text"]);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Note "),
        content: TextField(
          controller: editCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Update your note here...",
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",
                  style: TextStyle(color: Colors.deepPurple))),
          TextButton(
            onPressed: () {
              setState(() {
                notes[i]["text"] = editCtrl.text.trim();
                final now = DateTime.now();
                notes[i]["time"] =
                    "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Note updated successfully")),
              );
            },
            child: Text("Save",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void colorPickerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Pick a color "),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors
              .map((c) => GestureDetector(
                    onTap: () {
                      setState(() => selectedColor = c);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: c,
                          border: Border.all(
                              color: Colors.black26, width: 1.5),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favNotes = notes.where((n) => n["fav"]).toList();
    final normalNotes = notes.where((n) => !n["fav"]).toList();

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text("My Notes"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: noteCtrl,
                    decoration: InputDecoration(
                        hintText: "Write a note...",
                        border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.palette, color: Colors.deepPurple),
                  onPressed: colorPickerDialog,
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addNote,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple),
              child:
                  Text("Add Note", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            Expanded(
              child: notes.isEmpty
                  ? Center(child: Text("No notes yet "))
                  : ListView(
                      children: [
                        if (favNotes.isNotEmpty)
                          Text("⭐ Favourites",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple)),
                        ...favNotes.map((n) => noteCard(n)),
                        if (normalNotes.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("📒 All Notes",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple)),
                          ),
                        ...normalNotes.map((n) => noteCard(n)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noteCard(Map<String, dynamic> n) {
    int i = notes.indexOf(n);
    return Card(
      color: n["color"],
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(n["text"], style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          "Created: ${n["time"]}${n["reminder"] != null ? "\nReminder: ${n["reminder"]}" : ""}",
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
                icon: Icon(
                    n["fav"] ? Icons.favorite : Icons.favorite_border,
                    color: Colors.pink),
                onPressed: () => toggleFav(i)),
            IconButton(
                icon: Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () => editNoteDialog(i)),
            IconButton(
                icon: Icon(Icons.alarm_add, color: Colors.purpleAccent),
                onPressed: () => addReminder(i)),
            IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => deleteNote(i)),
          ],
        ),
      ),
    );
  }
}
