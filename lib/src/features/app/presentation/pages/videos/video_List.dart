import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:raah_e_nijaat/src/features/app/presentation/pages/videos/video_player.dart';
import '../../../utils/colors.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  bool _hasError = false;

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: _appBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : VideoList(
        channelId: 'PLSrBeYs6txhJljHxrSid8ytqtmP4WGq3Z',
        apiKey: 'AIzaSyArC4S0eZTllJaVL9WX_vV9-zDN9VUEKX4',
        searchQuery: _searchQuery,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        "Videos",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          color: blueColor,
        ),
      ),
      elevation: 0,
      backgroundColor: whiteColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search videos...',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: yellowColor),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: yellowColor),
                borderRadius: BorderRadius.circular(16),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VideoList extends StatelessWidget {
  final String channelId;
  final String apiKey;
  final String searchQuery;

  const VideoList({
    super.key,
    required this.channelId,
    required this.apiKey,
    required this.searchQuery,
  });

  Future<List<dynamic>> fetchYoutubeVideos(String playlistId, String apiKey) async {
    try {
      final playlistResponse = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails&playlistId=$playlistId&maxResults=10&key=$apiKey'));

      if (playlistResponse.statusCode != 200) {
        throw Exception('Failed to load videos');
      }

      final playlistData = json.decode(playlistResponse.body);
      final List<dynamic> videos = playlistData['items'];

      final videoIds = videos.map((video) => video['contentDetails']['videoId']).toList();

      final videoDetailsResponse = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=${videoIds.join(",")}&key=$apiKey'));

      if (videoDetailsResponse.statusCode != 200) {
        throw Exception('Failed to load video details');
      }

      final videoDetailsData = json.decode(videoDetailsResponse.body);
      final videoDetails = videoDetailsData['items'];

      for (int i = 0; i < videos.length; i++) {
        videos[i]['duration'] = videoDetails[i]['contentDetails']['duration'];
      }

      return videos;
    } catch (e) {
      throw Exception('Failed to fetch videos: $e');
    }
  }

  String formatDuration(String isoDuration) {
    RegExp regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');
    Match match = regex.firstMatch(isoDuration)!;

    String hours = match.group(1)?.replaceAll('H', '') ?? '00';
    String minutes = match.group(2)?.replaceAll('M', '') ?? '00';
    String seconds = match.group(3)?.replaceAll('S', '') ?? '00';

    if (hours.length < 2) hours = '0$hours';
    if (minutes.length < 2) minutes = '0$minutes';
    if (seconds.length < 2) seconds = '0$seconds';

    return '$hours:$minutes:$seconds';
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchYoutubeVideos(channelId, apiKey),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final videos = snapshot.data ?? [];
          final filteredVideos = videos.where((video) {
            final title = video['snippet']['title'].toString().toLowerCase();
            return title.contains(searchQuery.toLowerCase());
          }).toList();

          if (filteredVideos.isEmpty) {
            return const Center(child: Text('No videos found for your search'));
          }

          return ListView.builder(
            itemCount: filteredVideos.length,
            itemBuilder: (BuildContext context, int index) {
              final video = filteredVideos[index]['snippet'];
              final duration = formatDuration(filteredVideos[index]['duration']);
              final publishedAt = formatDate(video['publishedAt']);
              final videoId = filteredVideos[index]['contentDetails']['videoId'];
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: ListTile(
                  leading: Image.network(
                    video['thumbnails']['medium']['url'],
                    scale: 0.5,
                  ),
                  title: Text(
                    video['title'],
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                  ),
                  subtitle: Text(
                    '$duration\t\t\t\t\t\t\t\t\t\tPublished: $publishedAt',
                    style: const TextStyle(fontSize: 8),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(
                          videoId: videoId,
                          title: video['title'],
                          description: video['description'],
                          publishedAt: publishedAt,
                          duration: duration,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
