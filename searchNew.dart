import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inosens/logic/searchLogic/searchFun.dart';
import 'package:inosens/ui-components/dateTime/timeStampToDateTime.dart';
import 'package:inosens/ui-components/posts/postViewer.dart';

class SearchNew extends StatefulWidget {
  const SearchNew({Key key}) : super(key: key);

  @override
  _SearchNewState createState() => _SearchNewState();
}

class _SearchNewState extends State<SearchNew> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool searchfocus = false;
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      _onFocusChange();
    });
  }

  void _onFocusChange() {
    print("Focus: " + _focus.hasFocus.toString());
    if (_focus.hasFocus == true) {
      setState(() {
        searchfocus = true;
      });
    } else if (_focus.hasFocus == false) {
      setState(() {
        searchfocus = false;
      });
    }
  }

  loadData() async {
    if (searchFun.searchResults.length == 0) {
      setState(() {
        isLoading = true;
      });
      await searchFun.search(context, searchController.text.trim());
      setState(() {
        isLoading = false;
      });
    } else {
      await searchFun.searchMore(context, searchController.text.trim());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xFF915FB5), const Color(0xFFCA436B)],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter),
        ),
        child: Column(
          children: <Widget>[
            searchField(),
            // recentSearch(),
            trendingText(),
            trendingView(),
            recomendedText(),
            recomendedView()
          ],
        ),
      ),
    );
  }

  Widget recomendedView() {
    return searchfocus
        ? Container()
        : StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot){    
            if(!snapshot.hasData){
              return CircularProgressIndicator(
                strokeWidth: 1,
              );
            }
            return Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 140,
                        childAspectRatio:
                            MediaQuery.of(context).size.width / 3 / 180.0,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0),
                        itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Stack(children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                color: Colors.white,
                                shape: BoxShape.rectangle),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: Image.asset("assets/images/ic_play.png"))),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                color: Colors.black,
                              ),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  child: Image.network(
                                      snapshot.data.documents[index]['profileImageUrl'].toString()))
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.documents[index]['username'].toString(),
                                      style: TextStyle(fontSize: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ]);
                    }),
              ),
            );
          },
        );
  }

  Widget recomendedText() {
    return searchfocus
        ? Container()
        : Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Recomended",
                  style: TextStyle(color: Colors.white, fontSize: 17.0),
                ),
              ],
            ),
          );
  }

  Widget trendingView() {
    return searchfocus
        ? Container()
        : StreamBuilder(
          stream: Firestore.instance.collection('posts').snapshots(),
          builder: (BuildContext context, snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            return Container(
              height: 200.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.orange,
                            shape: BoxShape.rectangle),
                        width: 160.0,
                      ),
                    );
                  }),
            );
          },
        );
  }

  Widget trendingText() {
    return searchfocus
        ? Container()
        : Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Trending",
                  style: TextStyle(color: Colors.white, fontSize: 17.0),
                ),
              ],
            ),
          );
  }

  Widget recentSearch() {
    return searchfocus
        ? activeSearchView()
        : Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Recent Search",
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                ),
              ],
            ),
          );
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
          controller: searchController,
          onChanged: (String val) async {
            if (val.length > 1) {
              setState(() {
                isLoading = true;
              });
              await searchFun.search(context, searchController.text.trim());
              setState(() {
                isLoading = false;
              });
            }
          },
          focusNode: _focus,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(3.0),
              fillColor: Colors.black,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              suffix: Container(
                // color: Colors.orange,
                padding: EdgeInsets.only(right: 0.0),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await searchFun.search(
                        context, searchController.text.trim());
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              labelText: "Search",
              labelStyle: TextStyle(color: Colors.white),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: BorderSide.none))),
    );
  }

  Widget activeSearchView() {
    return isLoading
        ? Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
          )
        : Container(
            child: Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: searchFun.searchResults.length,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostViewer(
                                      postData: searchFun
                                          .searchResults[index].postData,
                                      userId: searchFun.searchResults[index]
                                          .userData.documentID,
                                    )));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundImage: searchFun.searchResults[index]
                                      .userData.data['profileImageUrl'] ==
                                  null
                              ? AssetImage("./assets/images/inosens.png")
                              : CachedNetworkImageProvider(searchFun
                                  .searchResults[index]
                                  .userData
                                  .data['profileImageUrl']),
                        ),
                        title: Text(
                          searchFun
                              .searchResults[index].userData.data['username'],
                          style: TextStyle(fontSize: 13.0),
                        ),
                        subtitle: Text(searchFun
                            .searchResults[index].postData.data['postTitle']),
                        trailing: Text(TimestampConvertor().organizeTimestamp(
                            searchFun.searchResults[index].postData
                                .data['postPostedOn'])),
                      ),
                    );
                  }),
            ),
          );
  }
}
