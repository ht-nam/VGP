import 'package:barcode_finder/barcode_finder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vgp/models/app_setting.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/widgets/base_screen/base_consumer_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vgp/viewmodels/app_setting_view_model.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends BaseConsumerState<ScannerScreen>{
  String? value;
  int quarterTurns = 0;
  late AsyncValue<AppSetting> _appSetting;

  @override
  Widget build(BuildContext context) {
    _appSetting = ref.watch(appSettingViewModelProvider);
    return Scaffold(
      body: Stack(
        // alignment: AlignmentDirectional.center,
        children: [
          _scanner(),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Align(
                        alignment: MediaQuery.of(context).size.width > 500 ? Alignment.center : Alignment.bottomCenter,
                        child: Text(
                          value ?? "",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: _appSetting.value?.largeTextSize),
                        ),
                    ),
                  ],
                ),
                // child: ,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        MediaQuery.of(context).size.width > 500 ? AppLocalizations.of(context)!.qrDetail : "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: _appSetting.value?.mediumTextSize),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: () async {
                              _scanFile().then((value) => setState(() {
                                this.value = value;
                              }));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(color: AppTheme.white,borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.photo, color: AppTheme.primaryColor),
                                  Text(
                                    "Photos",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryColor, fontSize: _appSetting.value?.mediumTextSize),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: InkWell(
                                onTap: () => context.pop(value ?? ''),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    "OK",
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontSize: _appSetting.value?.mediumTextSize),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    quarterTurns++;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(color: AppTheme.white,borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.rotate_right, color: AppTheme.primaryColor),
                                      Text(
                                        "Rotate",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryColor, fontSize: _appSetting.value?.mediumTextSize),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
                // child: ,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scanner() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: MobileScanner(
          controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates),
          onDetect: (BarcodeCapture barcodes) {
            setState(() {
              value = barcodes.barcodes[0].rawValue;
            });
            // Navigator.pop(context, barcodes.barcodes[0].rawValue);
          },
        ),
      ),
    );
  }

  Future<String?> _scanFile() async {
    // Used to pick a file from device storage
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
          type: FileType.image);
      if (pickedFile != null) {
        final filePath = pickedFile.files.single.path;
        if (filePath != null) {
          return await BarcodeFinder.scanFile(path: filePath);
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
