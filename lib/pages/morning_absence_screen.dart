import 'package:flutter/material.dart';
import 'package:logger/web.dart';

//Mock
const presenceList = [
  {"date": "2025-08-01", "status": "Presence"},
  {"date": "2025-08-02", "status": "Presence"},
  {"date": "2025-08-03", "status": "Presence"},
  {"date": "2025-08-04", "status": "Presence"},
  {"date": "2025-08-05", "status": "Presence"},
  {"date": "2025-08-06", "status": "Presence"},
  {"date": "2025-08-07", "status": "Presence"},
  {"date": "2025-08-08", "status": "Presence"},
];

const absenceList = [
  {'date': "2025-08-10", "status": "Absence"},
  {'date': "2025-08-11", "status": "Absence"},
  {'date': "2025-08-12", "status": "Absence"},
];

class MorningAbsenceScreen extends StatelessWidget {
  final String status;
  MorningAbsenceScreen({super.key, required this.status});
  var logger = Logger(printer: PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSizeHeader = constraints.maxWidth * 0.04;
        double fontSizeRow = constraints.maxWidth * 0.035;
        double rowHeight = constraints.maxHeight * 0.08;

        return Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              //Table Header
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF8Ec6E9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeHeader,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeHeader,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeHeader,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: status.contains('Presence')
                      ? presenceList.length
                      : absenceList.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                  itemBuilder: (context, index) {
                    final presenceItem = status.contains("Presence")
                        ? presenceList[index]
                        : absenceList[index];
                    return Container(
                      height: rowHeight,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: fontSizeRow,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${presenceItem['date']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: fontSizeRow,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${presenceItem['status']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: status.contains('Presence')
                                    ? Colors.blue.shade700
                                    : Colors.red.shade700,
                                fontSize: fontSizeRow,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF8Ec6E9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total $status: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeHeader,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      status.contains('Presence')
                          ? presenceList.length.toString()
                          : absenceList.length.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: fontSizeHeader,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
