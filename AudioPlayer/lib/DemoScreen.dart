import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/scheduler.dart';


class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> with TickerProviderStateMixin //nhớ cần include TickerProviderStateMixin để sử dụng createTicker.
{
  late Ticker _ticker;
  int _StartTimer = 0;
  //List<int> times = [120, 300, 900, 1800 , 2700, 5400]; // second
  //List<int> times = [1200, 3000, 9000, 18000, 27000, 54000]; // tenth of a second
  List<int> times = [100, 100, 100, 100, 100, 100]; // Test cho nhanh
  int currentIndex = 0; // để theo dõi phần tử hiện tại trong list

  List<int> containerWidths = [330, 300, 270, 240, 210, 180]; // Độ dài của container muốn thay đổi sau mỗi vòng

  int EndSlider = 0;

  double _currentSliderValue = 0.0;

  String formatTime(int timeInTenths) {
    int seconds = timeInTenths ~/ 10;
    final minutesPart = seconds ~/ 60;
    final secondsPart = seconds % 60;
    return "${minutesPart.toString().padLeft(2, '0')}' ${secondsPart.toString().padLeft(2, '0')}s";
  } //thêm một hàm vào lớp của bạn để chuyển đổi giá trị thời gian sang định dạng phút và giây:

  final _player = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _StartTimer = times[currentIndex];  // Initialize _StartTimer with the first value from times
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  //đếm ngược, slider đi tới
  void _onTick(Duration elapsed) { //một hàm callback được gọi sau mỗi khoảng thời gian, để cập nhật trạng thái của ứng dụng sau mỗi đơn vị thời gian nhất định.
    setState(() {
      _StartTimer = times[currentIndex] - (elapsed.inMilliseconds ~/ 100); //  cập nhật giá trị _StartTimer bằng cách lấy giá trị thời gian hiện tại của currentIndex từ danh sách times và trừ đi thời gian đã trôi qua (elapsed time)
      _currentSliderValue = times[currentIndex].toDouble() - _StartTimer.toDouble(); //  cập nhật giá trị _currentSliderValue bằng cách lấy giá trị times[currentIndex] và trừ đi _StartTimer. Điều này giúp tăng giá trị của Slider khi thời gian trôi qua.

      if (_StartTimer <= 0) { // nếu _StartTimer nhỏ hơn hoặc bằng 0, có nghĩa là công việc hiện tại đã hoàn thành
        if (currentIndex < times.length - 1) { // kiểm tra nếu currentIndex chưa đạt đến phần tử cuối cùng trong danh sách times
          currentIndex++;
          _ticker.stop(); //Sau đó dừng ticker hiện tại và tạo một ticker mới bằng cách gọi bên dưới
          _ticker = createTicker(_onTick); // Create a new ticker
          _ticker.start();  //Cuối cùng khởi động ticker mới bằng cách gọi _ticker.start().

        } else { //Nếu currentIndex đã đạt đến phần tử cuối cùng trong danh sách times, dừng ticker bằng cách gọi stop
          _ticker.stop();
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ticker.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8 ,1),
              colors: <Color>[
                Color(0xff1f005c),
                Color(0xff5b0060),
                Color(0xff870160),
                Color(0xffac255e),
                Color(0xffca485c),
                Color(0xffe16b5c),
                Color(0xfff39060),
                Color(0xffffb56b),
              ],
            )
        ),
        child: Column(
          children: [
            Container(
              color: Colors.white24,
              height: 50,
              child: const Center(
                child: Text("BA"),
              ),
            ),
            AppBar(
              backgroundColor: Colors.white10,
              title: Text("Focus", style: TextStyle(
                color: Colors.white70, // Màu của font text
                fontSize: 25,)),
              centerTitle: true,
              leading: IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back,color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.volume_up,color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white70,
                        ),
                        height: 280,
                        width: 280,
                        child: const Center(
                          child: Text("NA"),
                        )
                    ),
                    Container(
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black45,
                      ),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 160,
                      width: 350,
                      child: Column(
                        children: [
                          Container( // chữ thời gian
                            margin: EdgeInsets.only(top: 15),
                            child: Center(child: Text(formatTime(_StartTimer),
                              style: TextStyle(color: Colors.white,fontSize: 20),)),
                          ),

                          Container(
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  width: 330,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.white, // Màu của đường line khi slider có giá trị
                                      inactiveTrackColor: Colors.white70, // Màu của đường line khi slider không có giá trị
                                      trackHeight: 0.5, // Chiều cao của đường line
                                      thumbColor: Colors.white, // Màu của thumb (điểm trượt)
                                      overlayColor: Colors.blue.withOpacity(0.3), // Màu của overlay (hiển thị khi kéo thumb)
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 10), // Hình dạng của overlay
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.6), // Hình dạng của thumb
                                    ),
                                    child: Slider(value: _currentSliderValue,
                                        min: 0.0,
                                        max: (currentIndex < times.length) ? times[currentIndex].toDouble() : 0,
                                        onChanged: (onChanged){
                                          setState(() {
                                          });
                                        }),
                                  ),
                                ),
                                Positioned(
                                  top: 19,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 2,
                                            width: containerWidths[currentIndex].toDouble(),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(milliseconds: 300),
                                            alignment: Alignment.centerRight,
                                            height: 2,
                                            width: containerWidths[currentIndex].toDouble(),
                                            color: Colors.yellowAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            //height:70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  //color: Colors.orangeAccent,
                                  width: 60,
                                  child: GestureDetector (
                                    onTap: (){},
                                    child: Column(
                                      children: [
                                        Icon(Icons.skip_next, color: Colors.white, ),
                                        Text("SKIP", style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: GestureDetector (
                                    onTap: (){

                                    },
                                    child: Icon(Icons.check, color: Colors.white,),
                                  ),
                                ),
                                Container(
                                  //color: Colors.orangeAccent,
                                  width: 60,
                                  child: GestureDetector (
                                    onTap: (){},
                                    child: Column(
                                      children: [
                                        Icon(Icons.snooze,color: Colors.white,),
                                        Text("SNOOZE", style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration (
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: AssetImage('assets/image/fire-banner.jpg'),
                              fit: BoxFit.cover,
                            )
                        ),
                        margin: EdgeInsets.only( bottom: 10),
                        height: 120,
                        width: 350,
                        child: IconButton (
                          icon: Icon(
                            Icons.play_circle_fill,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: (){
                          },
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



