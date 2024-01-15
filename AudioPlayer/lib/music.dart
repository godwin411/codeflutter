import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final _player = AudioPlayer(); //Đối tượng AudioPlayer từ thư viện just_audio dùng để phát nhạc.
  bool isPlaying = false; // kiếm tra coi coi đang play hay tắt

  Duration duration = Duration.zero; //biến này chứa tổng thời gian của bài hát
  Duration position = Duration.zero; //biến này chứa thời gian hiện tại của bài hát đang phát

  @override
  void initState() { // được gọi khi StatefulWidget được khởi tạo.
    // TODO: implement initState
    super.initState();
    _musicInit();
  }

  // được gọi khi StatefulWidget được khởi tạo
  _musicInit() async{ //đang tải một tài nguyên âm thanh từ đường dẫn đã cung cấp và khởi tạo duration với thời lượng của tài nguyên đó
    var totalTime = await _player.setAsset("lib/assets/music/ES_El Fuego.mp3");
    duration = _player.duration!; //lắng nghe positionStream của _player
    setState(() {

      //this is for listen every seconds
      _player.positionStream.listen((event) { //cập nhật position mỗi khi có sự kiện mới.
        if (event != null){
        Duration temp = event as Duration;
          position  = temp;
          setState(() {});}
      });
    });
  }

  _playerAction() { //sẽ phát hoặc tạm dừng bài hát tùy thuộc vào giá trị hiện tại của isPlaying.
    if(isPlaying) {
      _player.pause();
      isPlaying = false;
    } else {
      _player.play();
      isPlaying = true;
    }
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Asset Music"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text("Music Name")),
          SizedBox(height: 30,),
          Slider( //Một thanh trượt (Slider) được sử dụng để thể hiện và điều chỉnh position của bài hát.
            min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
              final seekPosition = Duration(seconds: value.toInt());
              _player.seek(seekPosition); //Khi giá trị của thanh trượt thay đổi, _player sẽ nhảy tới vị trí tương ứng trong bài hát.
              setState(() {});
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(formatTime(position)),
              Text(formatTime(duration))],
          ),
          SizedBox(height: 30,),
          IconButton(
              iconSize: 38,
              onPressed: (){
                _playerAction();
                //_player.setAsset("lib/assets/music/ChimeSound.mp3");
              }, icon: isPlaying ? Icon(Icons.pause_circle) : Icon(Icons.play_arrow))
        ],
      ),
    );
  }
  String formatTime(Duration value) { //Phương thức formatTime chuyển đổi một Duration thành một chuỗi thời gian ở định dạng "HH:MM:SS".
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(value.inHours);
    final min = twoDigits(value.inMinutes.remainder(60));
    final sec = twoDigits(value.inSeconds.remainder(60));
    return[
      if(value.inHours>0) hours,min,sec].join(":");
  }
}
