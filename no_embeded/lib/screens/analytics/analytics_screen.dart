import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:no_embeded/components/bottom_information.dart';
import 'package:no_embeded/provider/data_provider.dart';
import 'package:no_embeded/provider/dropdown_provider.dart';
import 'package:no_embeded/services/sizeconfig.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DropdownProvider()),
        ChangeNotifierProvider.value(value: DataProvider()),
      ],
      builder: (ctx, wid) {
        final provider = Provider.of<DropdownProvider>(ctx, listen: true);
        final datas = Provider.of<DataProvider>(ctx, listen: false);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          datas.requestData(1);
          datas.requestMax(provider.serverString);
          datas.requestMin(provider.serverString);
        });

        return SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                datas.requestData(1);
                datas.requestMax(provider.serverString);
                datas.requestMin(provider.serverString);
              },
              mini: false,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.refresh),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(80),
                ),
                Text(
                  "최근 1시간 동안의",
                  style: GoogleFonts.notoSans(fontSize: 24),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                DropdownButton(
                  value: provider.selectedIndex,
                  items: provider.values
                      .map(
                        (e) => DropdownMenuItem(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(16),
                            ),
                            child: Text(
                              e,
                              style: GoogleFonts.notoSans(fontSize: 36),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: (idx) {
                    print(idx);
                    provider.selectedIndex = idx;
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(80),
                ),
                Consumer<DataProvider>(
                  builder: (ctx, item, _) {
                    if (item.status == Status.loading) {
                      return Column(
                        children: [
                          Text("Request Main Data"),
                          CircularProgressIndicator(),
                        ],
                      );
                    } else if (item.minStatus == Status.loading) {
                      return Column(
                        children: [
                          Text("Request min Data"),
                          CircularProgressIndicator(),
                        ],
                      );
                    } else if (item.maxStatus == Status.loading) {
                      return Column(
                        children: [
                          Text("Request max Data"),
                          CircularProgressIndicator(),
                        ],
                      );
                    } else if (item.status == Status.complete &&
                        item.minStatus == Status.complete &&
                        item.maxStatus == Status.complete) {
                      print(item.model.data.length);
                      item.model.data.forEach((element) {
                        print("DATA ${element.temp}");
                      });
                      final data = item.model.data
                          .map((e) => provider.serverString == "temp"
                              ? e.temp
                              : provider.serverString == "hum" ? e.hum : e.gas)
                          .toList();
                      final copy = data.toList();
                      copy.sort();
                      final min = copy.first;
                      final max = copy.last;
                      print("MIN : $min, MAX : $max");
                      return Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(200),
                            width: getProportionateScreenWidth(300),
                            child: LineChart(
                              LineChartData(
                                lineTouchData: LineTouchData(enabled: false),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xffaaaaaa),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 24,
                                    textStyle: const TextStyle(
                                      color: Color(0xffaaaaaa),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    getTitles: (value) {
                                      if ((value) % 2 == 0) return '';
                                      return '';
                                    },
                                    margin: 8,
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    textStyle: const TextStyle(
                                      color: Color(0xffaaaaaa),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    getTitles: (value) {
                                      return '${(value / (4) * (max - min)).toInt() + min} ';
                                    },
                                    reservedSize: 24,
                                    margin: 12,
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.symmetric(
                                    vertical: BorderSide(
                                      color: const Color(0xffaaaaaa),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                minX: 0,
                                maxX: data.length.toDouble(),
                                minY: 0,
                                maxY: 4,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(10, (index) {
                                      double ypos =
                                          (data[index] - min) / (max - min) * 4;
                                      print(ypos);
                                      return FlSpot(index.toDouble(), ypos);
                                    }),
                                    isCurved: false,
                                    barWidth: 2,
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: BottomInfo(
                                  title: "가장 높았던 날",
                                  value: provider.serverString == "temp"
                                      ? datas.max.data[0].temp
                                      : provider.serverString == "hum"
                                          ? datas.max.data[0].hum
                                          : datas.max.data[0].gas,
                                  icon: provider.rects[provider.selectedIndex],
                                  date: DateFormat('yyyy년 MM월 dd일')
                                      .format(datas.max.data[0].uploaded),
                                  time: DateFormat('hh시 mm분')
                                      .format(datas.max.data[0].uploaded),
                                ),
                              ),
                              Container(
                                height: getProportionateScreenHeight(178),
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: BottomInfo(
                                  title: "가장 낮았던 날",
                                  value: provider.serverString == "temp"
                                      ? datas.min.data[0].temp
                                      : provider.serverString == "hum"
                                          ? datas.min.data[0].hum
                                          : datas.min.data[0].gas,
                                  icon: provider.rects[provider.selectedIndex],
                                  date: DateFormat('yyyy년 MM월 dd일')
                                      .format(datas.min.data[0].uploaded),
                                  time: DateFormat('hh시 mm분')
                                      .format(datas.min.data[0].uploaded),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
