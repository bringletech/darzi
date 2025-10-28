import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darzi/colors.dart';

class SearchFieldReusable extends StatefulWidget {
  final String hintText;
  final double borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final List<String>? suggestionList;

  // 🔹 New external controller & onChanged
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchFieldReusable({
    super.key,
    this.hintText = "Search here",
    this.borderRadius = 8,
    this.fillColor,
    this.borderColor,
    this.onTap,
    this.suggestionList,
    this.controller,
    this.onChanged,
  });

  @override
  State<SearchFieldReusable> createState() => _SearchFieldReusableState();
}

class _SearchFieldReusableState extends State<SearchFieldReusable> {
  late final TextEditingController _textController;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _filteredItems = widget.suggestionList ?? [];
    _textController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _textController.text;

    // 🔹 Filter suggestions
    if (query.isEmpty) {
      setState(() {
        _filteredItems = widget.suggestionList ?? [];
      });
    } else {
      setState(() {
        _filteredItems = (widget.suggestionList ?? [])
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    // 🔹 Call external onChanged callback if provided
    if (widget.onChanged != null) {
      widget.onChanged!(query);
    }
  }

  void _clearSearch() {
    _textController.clear();
    setState(() {
      _filteredItems = widget.suggestionList ?? [];
    });

    if (widget.onChanged != null) {
      widget.onChanged!(""); // empty query
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textController.dispose(); // Only dispose internal controller
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _textController,
          onTap: widget.onTap,
          readOnly: widget.onTap != null,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.blackTextColor,
              size: 20,
            ),
            suffixIcon: _textController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.blackTextColor),
                    onPressed: _clearSearch,
                  )
                : null,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.roboto(
              fontSize: 16,
              color: AppColors.blackTextColor,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: widget.fillColor ?? AppColors.textColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.blackTextColor,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.blackTextColor,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_filteredItems.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColors.blackTextColor.withOpacity(0.2)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Text(
                    item,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.blackTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    _textController.text = item;
                    _onSearchChanged();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
