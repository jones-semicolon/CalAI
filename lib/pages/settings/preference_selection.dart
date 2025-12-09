import 'package:flutter/material.dart';

class PreferencesSection extends StatefulWidget {
  const PreferencesSection({super.key});

  @override
  State<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends State<PreferencesSection> {
  String appearance = "Light";
  bool addBurnedCalories = false;
  bool rolloverCalories = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: Colors.grey.shade700,
                  size: 26,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Preferences",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          _divider(),

          // 1 — Appearance
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // LEFT SIDE TEXTS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Appearance",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Choose light, dark, or system appearance",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // DROPDOWN WITH WHITE BG, ROUNDED, PADDING
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: appearance,
                      items: ["Light", "Dark", "Automatic"]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Center(
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => appearance = value!);
                      },
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _divider(),

          // 2 — Add Burned Calories
          GestureDetector(
            onTap: () {
              setState(() => addBurnedCalories = !addBurnedCalories);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Add Burned Calories",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Add burned calories to daily goal",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: addBurnedCalories,
                    onChanged: (v) {
                      setState(() => addBurnedCalories = v);
                    },
                  ),
                ],
              ),
            ),
          ),

          _divider(),

          // 3 — Rollover Calories
          GestureDetector(
            onTap: () {
              setState(() => rolloverCalories = !rolloverCalories);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rollover Calories",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Add up to 200 leftover calories into today's goal",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: rolloverCalories,
                    onChanged: (v) {
                      setState(() => rolloverCalories = v);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 1,
        color: Colors.grey.shade400,
      );
}
