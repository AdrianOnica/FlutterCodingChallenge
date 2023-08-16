import 'package:coding_challenge/bloc/app_block.dart';
import 'package:coding_challenge/bloc/app_event.dart';
import 'package:coding_challenge/bloc/app_state.dart';
import 'package:coding_challenge/model/Events.dart';
import 'package:coding_challenge/repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const FlutterCodingChallenge());
}

class FlutterCodingChallenge extends StatelessWidget {
  const FlutterCodingChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Coding Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
        create: (context) => Repository(),
        child: const BuildApp(),
      ),
    );
  }
}

class BuildApp extends StatefulWidget {
  const BuildApp({Key? key}) : super(key: key);

  @override
  State<BuildApp> createState() => _BuildAppState();
}

class _BuildAppState extends State<BuildApp> {
  List<Events> allEvents = List.empty();
  List<Events> filteredList = [];
  bool firstSearch = false;
  bool triggerGenresBox = false;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppBloc(RepositoryProvider.of<Repository>(context))
          ..add(LoadEvent()),
        child: Scaffold(body: _buildBody()));
  }

  BlocBuilder<AppBloc, AppState> _buildBody() {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state is LoadingState) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is GetEventsState) {
        allEvents = state.events;
        return Container(
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
            child: Stack(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 25),
                    child: Text("Events",
                        style: TextStyle(
                            fontSize: 35,
                            fontFamily: "NotoSerif",
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        _onSearchedTextChanges(_controller.text);
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.00),
                              borderSide:
                                  const BorderSide(color: Colors.orange)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 1.00, horizontal: 0.00),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.00),
                              borderSide: const BorderSide(color: Colors.grey)),
                          prefixIcon: const Icon(CupertinoIcons.search),
                          hintText: "Search",
                          suffixIcon: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // added line
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_controller.text.isNotEmpty)
                                  IconButton(
                                      onPressed: () {
                                        _onSearchedTextChanges(
                                            _controller.text = '');
                                      },
                                      icon: const Icon(
                                          CupertinoIcons.clear_circled_solid)),
                                const VerticalDivider(
                                    width: 2, color: Colors.grey),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      triggerGenresBox = !triggerGenresBox;
                                    });
                                  },
                                  child: const Text("All genres",
                                      style: TextStyle(color: Colors.black)),
                                ),
                                if (!triggerGenresBox)
                                  const Icon(CupertinoIcons.chevron_down)
                                else
                                  (const Icon(CupertinoIcons.chevron_up))
                              ])),
                    )),
                Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(25),
                        itemCount: filteredList.isEmpty && !firstSearch
                            ? allEvents.length
                            : filteredList.length,
                        itemBuilder: (ctx, index) {
                          if (filteredList.isEmpty && !firstSearch) {
                            return Event(
                                name: allEvents[index].name,
                                image: allEvents[index].images?.first.url,
                                date: allEvents[index].dates?.start?.localDate);
                          } else if (filteredList.isNotEmpty && firstSearch) {
                            return Event(
                                name: filteredList[index].name,
                                image: filteredList[index].images?.first.url,
                                date: filteredList[index]
                                    .dates
                                    ?.start
                                    ?.localDate);
                          }
                        }))
              ]),
              if (triggerGenresBox)
                GenresBox(
                  listOfEvents: state.events,
                  filteredList: filteredList.isEmpty && !firstSearch
                      ? allEvents
                      : filteredList,
                  updateParent: (e) => updateParentState(e),
                )
            ]));
      } else {
        return const Divider();
      }
    });
  }

  void _onSearchedTextChanges(String text) {
    firstSearch = true;
    List<Events> result = [];
    if (text.isEmpty) {
      result = allEvents;
    } else {
      result = allEvents
          .where((element) =>
              (element.name?.toLowerCase().contains(text.toLowerCase())) ==
              true)
          .toList();
    }
    setState(() {
      filteredList = result;
    });
  }

  void updateParentState(List<Events> filteredList) {
    setState(() {
      this.filteredList = filteredList;
    });
  }
}

class Event extends StatelessWidget {
  final String? name;
  final String? image;
  final String? date;

  const Event(
      {super.key, required this.name, required this.image, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, blurRadius: 6.0, offset: Offset(0.0, 1.0))
            ]),
        child: Row(
          children: [
            Image.network(image!, width: 100),
            Column(
              children: [
                const SizedBox(height: 25, width: 160),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SizedBox(
                        width: 180,
                        child: Text(name!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'NotoSerif',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.start))),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 75, 0),
                    child: Row(children: [
                      const Icon(
                        CupertinoIcons.calendar,
                        size: 13,
                      ),
                      Text(
                        date!,
                        style: const TextStyle(fontSize: 13),
                      )
                    ]))
              ],
            ),
            const Padding(
                padding: EdgeInsets.only(bottom: 75),
                child: Icon(CupertinoIcons.heart))
          ],
        ));
  }
}

class GenresBox extends StatefulWidget {
  Function(List<Events>) updateParent;
  final List<Events> listOfEvents;
  List<Events> filteredList;

  GenresBox({super.key,
    required this.listOfEvents,
    required this.filteredList,
    required this.updateParent,
  });

  @override
  State<GenresBox> createState() => _GenresBoxState();
}

class _GenresBoxState extends State<GenresBox> {
  Map<String, bool> mapOfGenres = {};

  @override
  void initState() {
    List<String?> listOfGenres = widget.listOfEvents
        .map((e) => e.classifications?.first.genre.name)
        .toSet()
        .toList();

    mapOfGenres = Map.fromIterable(listOfGenres,
        key: (item) => item, value: (item) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height / 6.5,
            MediaQuery.of(context).size.width / 25,
            0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, blurRadius: 6.0, offset: Offset(0.0, 1.0))
            ]),
        height: 300,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text("Filter by genre",
                  style: TextStyle(color: Colors.grey))),
          Expanded(child: StatefulBuilder(builder: (ctx, state) {
            return ListView(
                children: mapOfGenres.keys.map((key) {
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  child: Row(
                    children: [
                      Text(key),
                      Checkbox(
                          value: mapOfGenres[key]!,
                          onChanged: (bool? value) {
                            state(() {
                              mapOfGenres[key] = !mapOfGenres[key]!;
                            });
                            widget.updateParent(_filterByCheckbox());
                          })
                    ],
                  ));
            }).toList());
          }))
        ]),
      )
    ]);
  }

  List<Events> _filterByCheckbox() {
    return widget.filteredList.where((item) {
      return mapOfGenres.containsKey(item.classifications?.first.genre.name) &&
          mapOfGenres[item.classifications?.first.genre.name]!;
    }).toList();
  }
}
