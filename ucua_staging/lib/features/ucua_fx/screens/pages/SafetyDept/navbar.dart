import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Musab Ahmed'),
            accountEmail: const Text('Safety Department'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/pfp.png'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            otherAccountsPictures: const [
              Icon(
                Icons.shield,
                color: Colors.white,
                size: 30.0,
              )
            ],
          ),
          _buildSafetyActionDropdown(context),
          _buildSafetyConditionDropdown(context),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyActionDropdown(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.security),
      title: const Text('Safety Actions'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownItem(
                  context, 'Report Incident', '/view_action_formSD'),
              _buildDropdownItem(context, 'Action Plan', '/view_action_plan'),
              _buildDropdownItem(
                  context, 'Safety Procedures', '/safety_procedures'),

              _buildDropdownItem(context, 'Action Form', '/view_action_form'),
              //_buildDropdownItem(context, 'View Action Status', '/view_action_status'),
              _buildDropdownItem(
                  context, 'View Action List', '/view_action_form_list'),
              //_buildDropdownItem(context, 'Update Action', '/update_action_form'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyConditionDropdown(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.warning),
      title: const Text('Safety Conditions'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownItem(
                  context, 'Condition Form', '/view_condition_form'),
              _buildDropdownItem(
                  context, 'View Safety Status', '/view_safety_status'),
              _buildDropdownItem(
                  context, 'Safety Guidelines', '/safety_guidelines'),
              _buildDropdownItem(
                  context, 'Update Condition', '/update_condition_form'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownItem(BuildContext context, String title, String route) {
    return ListTile(
      leading: const Icon(Icons.arrow_right),
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
