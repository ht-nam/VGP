import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:vgp/models/app_setting.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/widgets/base_screen/base_consumer_state.dart';
import 'package:vgp/resources/widgets/custom_appbar.dart';
import 'package:vgp/routes/route_const.dart';
import 'package:vgp/viewmodels/app_setting_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({key}) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends BaseConsumerState<HomeScreen> {
  late AsyncValue<AppSetting> _appSetting;

  @override
  Widget build(BuildContext context) {
    _appSetting = ref.watch(appSettingViewModelProvider);

    return Scaffold(
      appBar: CustomAppBar(hasLeading: false, hasTrailing: false),
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFFF4F7FE),
          width: MediaQuery.of(context).size.width,
          height: getBodyHeight(context),
          child: _partsSelectionArea(context),
        )),
      ),
    );
  }

  Widget _partsSelectionArea(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ElevatedButton(
            onPressed: _scanCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: const Size(130, 100),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              AppLocalizations.of(context)!.scan,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: _appSetting.value?.mediumTextSize),
            ),
          ),
        ),
      );
    });
  }

  void _scanCode() {
    try {
      context.pushNamed(RouteConstants.scannerRouteName).then((value) async {
        showLoading(context, show: true, color: Colors.grey);
        // await Future.delayed(const Duration(seconds: 1));
        Position a = await _determinePosition();
        if (value != null && (value as String).isNotEmpty) {
          final List qrLocation = value.split(',');
          final distance = Geolocator.distanceBetween(a.latitude, a.longitude,
              double.parse(qrLocation[0]), double.parse(qrLocation[1]));
          showLoading(context, show: false);
          showSuccessToast('${AppLocalizations.of(context)!.scanDistanceSuccessToast} ${distance.floor()}m');
        }
        // latitude and longitude
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 10));
  }
}
