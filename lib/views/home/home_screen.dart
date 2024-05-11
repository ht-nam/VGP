import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vgp/main.dart';
import 'package:vgp/models/app_setting.dart';
import 'package:vgp/models/exceptions/base_exception.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/utils/data_sources/local.dart';
import 'package:vgp/resources/widgets/base_screen/base_consumer_state.dart';
import 'package:vgp/resources/widgets/custom_appbar.dart';
import 'package:vgp/routes/route_const.dart';
import 'package:vgp/viewmodels/app_setting_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vgp/viewmodels/geolocation_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({key}) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends BaseConsumerState<HomeScreen> {
  late AsyncValue<AppSetting> _appSetting;
  late GeolocationViewModel _geolocationViewModel;

  @override
  void initState() {
    _geolocationViewModel = GeolocationViewModel();
    super.initState();
  }

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

  void _changeLanguage() async {
    const language = 'en';
    (await SharedPre.instance)
        .setString(SharedPrefsConstants.LANGUAGE_KEY, language);
    MyApp.of(context)?.setLocale(Locale(language));
  }

  void _scanCode() async {
    if (!(await _geolocationViewModel.isEnableGps())) {
      _showGpsAlertDialog();
      return;
    }

    context.pushNamed(RouteConstants.scannerRouteName).then((value) async {
      showLoading(context, show: true, color: Colors.grey);
      // await Future.delayed(const Duration(seconds: 1));
      try {
        final location = await _geolocationViewModel.determinePosition();
        if (value != null && (value as String).isNotEmpty) {
          final List qrLocation = value.split(',');
          final distance = _geolocationViewModel.distanceBetween(
              location.latitude,
              location.longitude,
              double.parse(qrLocation[0]),
              double.parse(qrLocation[1]));
          showSuccessToast(
              '${AppLocalizations.of(context)!.scanDistanceSuccessToast} ${distance.floor()}m');
        } else {
          showSuccessToast('Your location: ${location.latitude}, ${location.longitude}');
        }
      } on BaseException catch (e) {
        showErrorToast(e.message ?? '');
      }
      showLoading(context, show: false);
      // latitude and longitude
    });
  }

  void _showGpsAlertDialog() {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => context.pop(),
    );
    Widget continueButton = TextButton(
      child: const Text("Go to settings"),
      onPressed: () async {
        await _geolocationViewModel.openLocationSettings();
        context.pop();
      },
    );

    AlertDialog dialogModal = AlertDialog(
      content: Text("GPS is disabled in your device. Enable it?"),
      actions: [
        cancelButton,
        continueButton,
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
    );
    showCenterPopUpDialog(context, ref, dialogModal);
  }
}
