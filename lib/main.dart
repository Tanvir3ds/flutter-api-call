import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/product_details.dart';
import 'package:http/http.dart' as http;

//Make a network request
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('http://myapppython.pythonanywhere.com/api/books/');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}



// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int price;
  final String title;
  final String img;

  Photo({this.price, this.title, this.img});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      
      title: json['title'] as String,
      img: json['img'] as String,
      price: json['price'] as int,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Books';

    return MaterialApp(
      title: appTitle,
      
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(title),
        actions: <Widget>[
           new IconButton(icon: Icon(Icons.search,color: Colors.white), onPressed: (){}),
          new IconButton(icon: Icon(Icons.shopping_cart,color: Colors.white), onPressed: (){})
        ],
      ),

    
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
//             header part
            new UserAccountsDrawerHeader(
              accountName: Text('Tanvir'),
              accountEmail: Text('Tanvir@gmail.com'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.red,
              ),
            ),

//            body

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Home Page'),
                
              ),
            ),

            InkWell(
              onTap: (){
                
              },
              child: ListTile(
                title: Text('My account'),
                
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My order'),
                
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Shooping cart'),
                
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Favourites'),
               
              ),
            ),



            Divider(),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Settings'),
              
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('About'),
               
              ),
            ),



          ],
        ),
      ),

      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        //return Image.network(photos[index].thumbnailUrl);
        return Single_prod(
          prod_name: photos[index].title,
          prod_picture: photos[index].img,
          prod_price: photos[index].price,
        );

        //return Image.network(photos[index].thumbnailUrl);
        //return ListTile(
        //title: Text(photos[index].title),

        //);

        //trial...........................................................................................


        //trial///........................................................................................
      },
    );
  }
}



class Single_prod extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_price;

  
  Single_prod({
    this.prod_name,
    this.prod_picture,
    this.prod_price,
  
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Hero(
          tag: prod_name,
          child: Material(
            child: InkWell(


              //details trial
              onTap: ()=> Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context)=> new ProductDetails(
                    //value passint in products to product_details class
                    product_details_name: prod_name,
                    
                    product_details_picture: prod_picture,
                    product_details_price: prod_price,


                  ))),
              //end product details


              child: GridTile(
                  footer: Container(
                      color: Colors.white70,
                      child: new Row(children: <Widget>[
                        Expanded(
                          child: new Text(prod_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                        ),
                        new Text("\$${prod_price}",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
                      ],)
                  ),
                  child: Image.network(
                     //return Image.network(photos[index].thumbnailUrl);
                    prod_picture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}

