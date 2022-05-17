import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'home_page.dart';

class AnalyticsPage extends StatefulWidget {
  AnalyticsPage(this.analyticsData);
  var analyticsData;
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int plan = 0;
  int completedPlan = 0;

  int groupPlan = 0;
  int groupCompleted = 0;

  final List<ChartData> chartData = [];

  final List<ChartData> chartDataPlan = [];

  final List<ColumnChartData> columnChartData = [
    ColumnChartData(2010, 35, 23),
    ColumnChartData(2011, 38, 49),
    ColumnChartData(2012, 34, 12),
    ColumnChartData(2013, 52, 33),
    ColumnChartData(2014, 40, 30)
  ];
  @override
  void initState() {
    chartDataPlan.add(
      ChartData(
          'Completed',
          double.parse(widget.analyticsData['completed'].toString()),
          Colors.redAccent),
    );
    chartDataPlan.add(ChartData(
        'Incompleted',
        double.parse(
            (widget.analyticsData['plan'] - widget.analyticsData['completed'])
                .toString()),
        Colors.blueAccent));

    chartData.add(ChartData(
        'Boszhan',
        double.parse(widget.analyticsData['brands'][0]['plan'].toString()),
        Colors.yellow));
    chartData.add(ChartData(
        'PD',
        double.parse(widget.analyticsData['brands'][1]['plan'].toString()),
        Colors.green));

    plan = widget.analyticsData['plan'];
    completedPlan = widget.analyticsData['completed'];
    groupPlan = widget.analyticsData['group_plan'];
    groupCompleted = widget.analyticsData['group_completed'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bbq_bg.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Scaffold(
              backgroundColor: Colors.white.withOpacity(0.85),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            child: SizedBox(
                              child: Image.asset("assets/images/logo.png"),
                              width: MediaQuery.of(context).size.width * 0.2,
                            )),
                        Spacer(),
                        Text(
                          'Мотивирующий отчет'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 34),
                        ),
                        Spacer(),
                      ],
                    ),
                    Divider(
                      color: Colors.yellow[700],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            children: [
                              // Text(
                              //   'Вы на 7-ом месте за декабрь 2022г.',
                              //   style: TextStyle(
                              //       fontSize: 18, fontWeight: FontWeight.bold),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(30),
                              //   child: SfCartesianChart(
                              //       // Columns will be rendered back to back
                              //       enableSideBySideSeriesPlacement: false,
                              //       series: <ChartSeries<ColumnChartData, int>>[
                              //         ColumnSeries<ColumnChartData, int>(
                              //             dataSource: columnChartData,
                              //             xValueMapper:
                              //                 (ColumnChartData data, _) =>
                              //                     data.x,
                              //             yValueMapper:
                              //                 (ColumnChartData data, _) =>
                              //                     data.y),
                              //       ]),
                              // ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: SfCircularChart(
                                                series: <CircularSeries>[
                                                  // Render pie chart
                                                  PieSeries<ChartData, String>(
                                                      dataSource: chartDataPlan,
                                                      pointColorMapper:
                                                          (ChartData data, _) =>
                                                              data.color,
                                                      xValueMapper:
                                                          (ChartData data, _) =>
                                                              data.x,
                                                      yValueMapper:
                                                          (ChartData data, _) =>
                                                              data.y)
                                                ]),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: Colors.redAccent,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text('Выполнено'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: Colors.blueAccent,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                  width: 150,
                                                  child: Text('Осталось')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Text(
                                    'Ваш план составляет: ${plan} тг',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Text(
                                    'На данный момент выполнено: ${completedPlan} тг',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: SfCircularChart(
                                            series: <CircularSeries>[
                                              // Render pie chart
                                              PieSeries<ChartData, String>(
                                                  dataSource: chartData,
                                                  pointColorMapper:
                                                      (ChartData data, _) =>
                                                          data.color,
                                                  xValueMapper:
                                                      (ChartData data, _) =>
                                                          data.x,
                                                  yValueMapper:
                                                      (ChartData data, _) =>
                                                          data.y)
                                            ]),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text('Boszhan'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            color: Colors.yellow,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                              width: 150,
                                              child: Text(
                                                  'Первомайские деликатесы')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              for (int i = 0;
                                  i < widget.analyticsData['brands'].length;
                                  i++)
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Text(
                                        widget.analyticsData['brands'][i]
                                            ['brand']['name'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Text(
                                        '${widget.analyticsData['brands'][i]['plan']} тг/ ${widget.analyticsData['brands'][i]['completed']} тг',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Text(
                                    'По команде супервайзера ${widget.analyticsData['group_name']}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Text(
                                    'План по команде составляет: ${groupPlan} тг',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Text(
                                    'На данный момент выполнено: ${groupCompleted} тг',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            children: [
                              for (int i = 0;
                                  i <
                                      widget
                                          .analyticsData['group_brands'].length;
                                  i++)
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Text(
                                        widget.analyticsData['group_brands'][i]
                                            ['brand']['name'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Text(
                                        '${widget.analyticsData['group_brands'][i]['plan']} тг/ ${widget.analyticsData['group_brands'][i]['completed']} тг',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class ColumnChartData {
  ColumnChartData(this.x, this.y, this.y1);
  final int x;
  final double y;
  final double y1;
}
