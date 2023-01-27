import 'package:covid_19/View/Details_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Services/states_services.dart';
class CountriesList extends StatefulWidget {
  const CountriesList({Key? key}) : super(key: key);

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title:Text("Covid-19"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value){
                  setState(() {
                  });
                },
                controller: searchController,cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: "Search With Country Name",
                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: BorderSide(color: Colors.black)),
                   enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(25))
                   // borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            Expanded(
              child: FutureBuilder(
                future: statesServices.fetchCountriesRecord(),
                  builder: (context,AsyncSnapshot<List<dynamic>>snapshot){
                    if(!snapshot.hasData){
                        return ListView.builder(
                            itemCount: 15,
                            itemBuilder: (context,index){
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade700,
                                  highlightColor: Colors.grey.shade100,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        height: 10,
                                        width: 50,
                                        color: Colors.white,
                                      ),
                                      title: Container(
                                        height: 10,
                                        width: 89,
                                        color: Colors.white,
                                    ),
                                    subtitle: Container(
                                      height: 10,
                                      width: 89,
                                      color: Colors.white,
                                    ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                          itemBuilder: (context,index) {
                            String name = snapshot.data![index]['country'];
                            if (searchController.text.isEmpty) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap:(){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsScreen(
                                       name: snapshot.data![index]['country'].toString(),
                                       image: snapshot.data![index]['countryInfo']['flag'].toString(),
                                       TotalCases: snapshot.data![index]['cases'],
                                       Tests: snapshot.data![index]['tests'],
                                       TodayCases: snapshot.data![index]['todayCases'],
                                       Deaths: snapshot.data![index]['deaths'],
                                       ActiveCases: snapshot.data![index]['active'],
                                       Recovery: snapshot.data![index]['recovered'],
                                       Population: snapshot.data![index]['population'],
                                       Critical: snapshot.data![index]['critical'],
                                     )));
                              },
                                    child: ListTile(
                                      leading: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(snapshot
                                            .data![index]['countryInfo']['flag']),
                                      ),
                                      title: Text(
                                          snapshot.data![index]['country']),
                                      subtitle: Text(
                                          snapshot.data![index]['cases']
                                              .toString()),
                                    ),
                                  ),
                                ],
                              );
                            }
                            else if (name.toLowerCase().contains(
                                searchController.text.toLowerCase())) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Image(
                                      height: 50,
                                      width: 50,
                                      image: NetworkImage(snapshot
                                          .data![index]['countryInfo']['flag']),
                                    ),
                                    title: Text(
                                        snapshot.data![index]['country']),
                                    subtitle: Text(
                                        snapshot.data![index]['cases']
                                            .toString()),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
