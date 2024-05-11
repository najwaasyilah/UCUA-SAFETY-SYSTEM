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
            accountName: const Text('Aiman Haiqal'),
            accountEmail: const Text('aiman020404@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/pfp.png'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          _buildActionDropdown(context),
          _buildConditionDropdown(context),
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

  Widget _buildActionDropdown(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.description),
      title: const Text('Actions'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownItem(context, 'Action Form', '/view_action_form'),
              _buildDropdownItem(
                  context, 'View Action Status', '/view_action_status'),
              _buildDropdownItem(
                  context, 'View Action List', '/view_action_form_list'),
              _buildDropdownItem(
                  context, 'Update Action', '/update_action_form'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConditionDropdown(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.description),
      title: const Text('Conditions'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownItem(
                  context, 'Condition Form', '/view_condition_form'),
              _buildDropdownItem(
                  context, 'View Condition Status', '/view_condition_status'),
              _buildDropdownItem(
                  context, 'View Condition List', '/view_condition_form_list'),
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
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
