import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/core/session.dart';
import 'package:tugas_akhir/modelviews/setting_view_models.dart';
import 'package:tugas_akhir/views/bottom_nav.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    void checkSession() async {
      final hasSession = await Provider.of<SessionCheck>(
        context,
        listen: false,
      ).sessionCheck();

      if (hasSession) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<SettingsViewModel>().loadSettings();
        });
      }
    }

    checkSession();
    return const _SettingsPage();
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          ListTile(
            title: Text("Currency"),
            trailing: DropdownButton<String>(
              value: vm.settings.currency,
              items: ['USD', 'EUR', 'IDR']
                  .map(
                    (c) => DropdownMenuItem<String>(value: c, child: Text(c)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) vm.updateCurrency(value);
              },
            ),
          ),
          ListTile(
            title: Text("Timezone"),
            trailing: DropdownButton<String>(
              value: vm.settings.timezone,
              items:
                  [
                        'UTC',
                        'Asia/Dubai',
                        'Asia/Jakarta',
                        'Europe/Berlin',
                        'America/New_York',
                      ]
                      .map(
                        (tz) => DropdownMenuItem<String>(
                          value: tz,
                          child: Text(tz),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) vm.updateTimezone(value);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 3),
    );
  }
}