import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FluxOSAboutDialog extends StatefulWidget {
  const FluxOSAboutDialog({super.key});

  @override
  State<FluxOSAboutDialog> createState() => _FluxOSAboutDialogState();
}

class _FluxOSAboutDialogState extends State<FluxOSAboutDialog> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'FluxOS Dashboard',
      ),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Theme.of(context).textTheme.displayLarge?.color ?? Colors.black,
        fontFamily: 'Montserrat',
        package: 'flutter_base',
      ),
      actionsOverflowButtonSpacing: 20,
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Theme.of(context).primaryColor;
                },
              ),
            ),
            child: const Text("Close")),
      ],
      content: Text('v${_packageInfo.version} (build ${_packageInfo.buildNumber})'),
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}
