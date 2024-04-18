import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool oneWay = false;

  void changeSelectedManyWay(int position) {
    setState(() {
      oneWay = !oneWay;
    });
  }

  TextEditingController flyFromController = new TextEditingController();
  TextEditingController flyToController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [

              SizedBox(height: 20),

              Container(
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      left: oneWay ? 0 : 180, // Assumes the container is 300px wide
                      right: oneWay ? 180 : 0,
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () => changeSelectedManyWay(1),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                              alignment: Alignment.center,
                              child: Text(
                                "W jedną stronę",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20, fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => changeSelectedManyWay(2),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                              alignment: Alignment.center,
                              child: Text(
                                "W dwie strony",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20, fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontSize: 20,color: Colors.blueGrey[800]),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Skąd',
                          filled: true,
                          labelStyle: TextStyle(color: Colors.blueGrey[800]),
                        ),
                        controller: flyFromController,
                      ),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.swap_horizontal_circle,
                      size: 40,)
                    ),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontSize: 20,color: Colors.blueGrey[800]),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Dokąd',
                          filled: true,
                          labelStyle: TextStyle(color: Colors.blueGrey[800]),
                        ),
                        controller: flyToController,
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      )
    );
  }
}
