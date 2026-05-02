import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchFilterHeader extends StatelessWidget {
  const SearchFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.darkBackground.withOpacity(0.9),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.darkSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.metallicLight, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: const TextField(
              style: TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search addresses, names, or tags...',
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                prefixIcon: Icon(Icons.search, color: AppTheme.accentOrange),
                suffixIcon: Icon(Icons.tune, color: AppTheme.textSecondary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', isSelected: true),
                _buildFilterChip('Plumbing', icon: Icons.water_drop),
                _buildFilterChip('Electrical', icon: Icons.bolt),
                _buildFilterChip('HVAC', icon: Icons.ac_unit),
                _buildFilterChip('Bad Payer 🚩', isDanger: true),
                _buildFilterChip('No Permits 🚩', isDanger: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false, IconData? icon, bool isDanger = false}) {
    final Color primaryColor = isDanger ? Colors.redAccent : AppTheme.accentOrange;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor.withOpacity(0.2) : AppTheme.darkSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? primaryColor : AppTheme.metallicLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: isSelected ? primaryColor : AppTheme.textSecondary),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? primaryColor : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
