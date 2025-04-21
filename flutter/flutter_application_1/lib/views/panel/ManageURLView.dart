import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter_application_1/services/urlservices.dart';

class ManageURLsView extends StatefulWidget {
  @override
  _ManageURLsViewState createState() => _ManageURLsViewState();
}

class _ManageURLsViewState extends State<ManageURLsView> {
  List<Map<String, dynamic>> _urls = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchURLs();
  }

  // ✅ Fetch URL Data
  Future<void> _fetchURLs() async {
    try {
      final urls = await UrlService.fetchURLs();
      setState(() {
        _urls = urls;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      body: Container(
        color: Color(0xFFF8F8FF), // ✅ White Pearl background color
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Title
            Text(
              'Manage Shortened URLs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 20),

            // 🔹 Show Loading or Error Message
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_hasError)
              Center(
                child: Text(
                  'Failed to load data. Please try again!',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              )
            else
              // 🔹 Table UI
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 20,
                      border: TableBorder.all(color: Colors.black26), // Softer border color
                      headingRowColor: WidgetStateColor.resolveWith((states) => Colors.purple.shade300),
                      columns: [
                        DataColumn(label: Text('Origin URL', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Short URL', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Created Date', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Expired Date', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                      ],
                      rows: _urls.map((url) {
                        return DataRow(cells: [
                          DataCell(SizedBox(
                            width: 200,
                            child: SelectableText(url['origin_URL'], style: TextStyle(color: Colors.black87)),
                          )),
                          DataCell(SelectableText(url['short_URL'], style: TextStyle(color: Colors.black87))),
                          DataCell(Text(url['create_date'], style: TextStyle(color: Colors.black87))),
                          DataCell(Text(url['expired_date'], style: TextStyle(color: Colors.black87))),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
