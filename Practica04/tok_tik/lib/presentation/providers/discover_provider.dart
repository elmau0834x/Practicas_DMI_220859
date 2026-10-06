import 'package:flutter/widgets.dart';
import 'package:tok_tik/domain/entities/video_post.dart';

class DiscoverProvider extends ChangeNotifier {
  
  bool initialLoading = true;
  List<VideoPost> videos = [];
  
  Future<void> loadNextPage() async{
    //Todo: Cargar videos

    notifyListeners();
  }
}