import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';


class Locationinput extends StatefulWidget {
  final Function onSelectplace;

   Locationinput( this.onSelectplace) ;

  @override
  State<Locationinput> createState() => _LocationinputState();
}

class _LocationinputState extends State<Locationinput> {
  String? _previewimageUrl;

 void _showPreview( lat, lng){
  final staticMapImageUrl= LocationHelper.generateLocationPreviewImage(
    latitude: lat,
    longitude: lng,
  );
   setState(() {
      _previewimageUrl = staticMapImageUrl;
    });
 }


  Future<void> _getCurrentUserLocation() async {
    try {
       final locData = await Location().getLocation();
        _showPreview(locData.latitude, locData.longitude);
    widget.onSelectplace(locData.latitude,locData.longitude);
    } catch (error) {
      return;
    }
   
  }


  Future<void> _selectOnMap() async {
    final  selectedLocation=await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if(selectedLocation== null){
      return;
    }
    _showPreview(selectedLocation.latitude,selectedLocation.longitude);
   widget.onSelectplace(selectedLocation.latitude,selectedLocation.longitude);
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 178,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewimageUrl == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewimageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //TextButton.icon
          children: [
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Current Locatiion"),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text("Select on Map"),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
