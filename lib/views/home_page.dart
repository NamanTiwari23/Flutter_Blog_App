import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/services/crud.dart';
import 'package:flutterapp/views/createblog.dart';

class HomePage extends StatelessWidget {
  final CrudMethods crudMethods = CrudMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VIT BLOG',
          style: TextStyle(
            fontFamily: 'RobotoMono-Bold',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(), // Ensure the scroll bar is always visible
                child: BlogsList(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateBlog()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('Create Blog'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BlogsList() {
    return FutureBuilder<QuerySnapshot>(
      future: crudMethods.getData(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            final data = snapshot.data!.docs;
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          data[index]['imgUrl'],
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data[index]["title"],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width - 32, // Adjust width as needed
                            child: Text(
                              data[index]["desc"],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.yellow,
                              ),
                              maxLines: 3, // Limit description to 3 lines
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
    );
  }
}

