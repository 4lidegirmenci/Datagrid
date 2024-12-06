import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:faker/faker.dart';
import 'dart:math';

class DataGridExample extends StatefulWidget {
  @override
  _DataGridExampleState createState() => _DataGridExampleState();
}

class _DataGridExampleState extends State<DataGridExample> {
  late EmployeeDataSource employeeDataSource;
  final Faker _faker = Faker();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    employeeDataSource = EmployeeDataSource(employees: generateRandomEmployees());
  }

  List<Employee> generateRandomEmployees() {
    int count = _random.nextInt(20) + 1;
    return List.generate(count, (index) {
      return Employee(
        1000 + index,
        _faker.person.name(),
        _faker.job.title(),
        _faker.address.city(),
        _faker.date.dateTime(),
        _faker.company.name(),
        _faker.lorem.word(),
        _faker.randomGenerator.integer(70001) + 30000,
        _faker.person.lastName(),
        _faker.phoneNumber.us(),
        _faker.internet.email(),
        _faker.address.streetName(),
        _faker.company.suffix(),
        _faker.lorem.sentence(),
        _faker.randomGenerator.decimal(),
        _faker.randomGenerator.integer(50),
        _faker.randomGenerator.boolean(),
        DateTime.now().add(Duration(hours: _random.nextInt(24))),
        _faker.food.dish(),
        _faker.lorem.word(),
      );
    });
  }

  Future<void> exportToExcel() async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

    // Headers
    final List<String> headers = [
      'ID',
      'Name',
      'Designation',
      'City',
      'Join Date',
      'Company',
      'Department',
      'Salary',
      'Last Name',
      'Phone',
      'Email',
      'Street',
      'Suffix',
      'Bio',
      'Rating',
      'Team Size',
      'Is Active',
      'Shift Time',
      'Favorite Food',
      'Keyword',
    ];
    for (int i = 0; i < headers.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
    }

    // Rows
    for (int rowIndex = 0; rowIndex < employeeDataSource.rows.length; rowIndex++) {
      final row = employeeDataSource.rows[rowIndex];
      for (int colIndex = 0; colIndex < row.getCells().length; colIndex++) {
        sheet.getRangeByIndex(rowIndex + 2, colIndex + 1).setText(row.getCells()[colIndex].value.toString());
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  Future<void> exportToPdf() async {
    final PdfDocument document = PdfDocument();
    final PdfGrid pdfGrid = PdfGrid();

    // Headers
    pdfGrid.columns.add(count: 20);
    final PdfGridRow headerRow = pdfGrid.headers.add(1)[0];
    final List<String> headers = [
      'ID',
      'Name',
      'Designation',
      'City',
      'Join Date',
      'Company',
      'Department',
      'Salary',
      'Last Name',
      'Phone',
      'Email',
      'Street',
      'Suffix',
      'Bio',
      'Rating',
      'Team Size',
      'Is Active',
      'Shift Time',
      'Favorite Food',
      'Keyword',
    ];
    for (int i = 0; i < headers.length; i++) {
      headerRow.cells[i].value = headers[i];
    }

    // Rows
    for (final row in employeeDataSource.rows) {
      final PdfGridRow pdfRow = pdfGrid.rows.add();
      for (int colIndex = 0; colIndex < row.getCells().length; colIndex++) {
        pdfRow.cells[colIndex].value = row.getCells()[colIndex].value.toString();
      }
    }

    pdfGrid.draw(
      page: document.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 500, 700),
    );

    final List<int> bytes = await document.save();
    document.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/Output.pdf';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> columnHeaders = [
      'ID',
      'Name',
      'Designation',
      'City',
      'Join Date',
      'Company',
      'Department',
      'Salary',
      'Last Name',
      'Phone',
      'Email',
      'Street',
      'Suffix',
      'Bio',
      'Rating',
      'Team Size',
      'Is Active',
      'Shift Time',
      'Favorite Food',
      'Keyword',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion DataGrid - 20 Columns'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {
              employeeDataSource = EmployeeDataSource(employees: generateRandomEmployees());
            }),
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: exportToPdf,
          ),
          IconButton(
            icon: Icon(Icons.table_chart),
            onPressed: exportToExcel,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 2000,
          child: SfDataGrid(
            source: employeeDataSource,
            columnWidthMode: ColumnWidthMode.auto,
            columns: columnHeaders.map((header) {
              return GridColumn(
                columnName: header,
                label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(
                    header,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class Employee {
  Employee(
      this.id,
      this.name,
      this.designation,
      this.city,
      this.joinDate,
      this.company,
      this.department,
      this.salary,
      this.lastName,
      this.phone,
      this.email,
      this.street,
      this.suffix,
      this.bio,
      this.rating,
      this.teamSize,
      this.isActive,
      this.shiftTime,
      this.favoriteFood,
      this.keyword,
      );

  final int id;
  final String name;
  final String designation;
  final String city;
  final DateTime joinDate;
  final String company;
  final String department;
  final int salary;
  final String lastName;
  final String phone;
  final String email;
  final String street;
  final String suffix;
  final String bio;
  final double rating;
  final int teamSize;
  final bool isActive;
  final DateTime shiftTime;
  final String favoriteFood;
  final String keyword;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employees}) {
    _employees = employees
        .map<DataGridRow>((employee) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'ID', value: employee.id),
      DataGridCell<String>(columnName: 'Name', value: employee.name),
      DataGridCell<String>(columnName: 'Designation', value: employee.designation),
      DataGridCell<String>(columnName: 'City', value: employee.city),
      DataGridCell<DateTime>(columnName: 'Join Date', value: employee.joinDate),
      DataGridCell<String>(columnName: 'Company', value: employee.company),
      DataGridCell<String>(columnName: 'Department', value: employee.department),
      DataGridCell<int>(columnName: 'Salary', value: employee.salary),
      DataGridCell<String>(columnName: 'Last Name', value: employee.lastName),
      DataGridCell<String>(columnName: 'Phone', value: employee.phone),
      DataGridCell<String>(columnName: 'Email', value: employee.email),
      DataGridCell<String>(columnName: 'Street', value: employee.street),
      DataGridCell<String>(columnName: 'Suffix', value: employee.suffix),
      DataGridCell<String>(columnName: 'Bio', value: employee.bio),
      DataGridCell<double>(columnName: 'Rating', value: employee.rating),
      DataGridCell<int>(columnName: 'Team Size', value: employee.teamSize),
      DataGridCell<bool>(columnName: 'Is Active', value: employee.isActive),
      DataGridCell<DateTime>(columnName: 'Shift Time', value: employee.shiftTime),
      DataGridCell<String>(columnName: 'Favorite Food', value: employee.favoriteFood),
      DataGridCell<String>(columnName: 'Keyword', value: employee.keyword),
    ]))
        .toList();
  }

  late List<DataGridRow> _employees;

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}