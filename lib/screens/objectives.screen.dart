import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:little_light/services/littlelight/littlelight.service.dart';
import 'package:little_light/services/littlelight/models/tracked_objective.model.dart';
import 'package:little_light/widgets/common/translated_text.widget.dart';
import 'package:little_light/widgets/inventory_tabs/inventory_notification.widget.dart';
import 'package:little_light/widgets/presentation_nodes/record_item.widget.dart';

class ObjectivesScreen extends StatefulWidget {
  @override
  LoadoutScreenState createState() => new LoadoutScreenState();
}

class LoadoutScreenState extends State<ObjectivesScreen> {
  List<TrackedObjective> objectives;

  @override
  void initState() {
    super.initState();
    loadLoadouts();
  }

  void loadLoadouts() async {
    LittleLightService service = LittleLightService();
    objectives = await service.getTrackedObjectives();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            // actions: <Widget>[
            //   IconButton(
            //       icon: Icon(Icons.add_circle_outline), onPressed: () async {})
            // ],
            title: TranslatedTextWidget("Objectives")),
        body: buildBody(context),
      ),
      InventoryNotificationWidget(key: Key("notification_widget"), barHeight: 0,)
    ]);
  }

  Widget buildBody(BuildContext context) {
    if (objectives == null) {
      return Container();
    }

    if (objectives.length == 0) {
      return Container(
          padding: EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TranslatedTextWidget(
                  "You have no loadouts yet. Create your first one.",
                  textAlign: TextAlign.center,
                ),
                Container(height: 16),
              ]));
    }

    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(4),
      crossAxisCount: 30,
      itemCount: objectives.length,
      itemBuilder: (BuildContext context, int index) => getItem(context, index),
      staggeredTileBuilder: (int index) => getTileBuilder(index),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  StaggeredTile getTileBuilder(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    return StaggeredTile.fit(screenWidth > 480 ? 15 : 30);
  }

  Widget getItem(BuildContext context, int index) {
    TrackedObjective objective = objectives[index];
    return RecordItemWidget(
      hash: objective.hash,
      key: Key("loadout_${objective.hash}"),
    );
  }
}
