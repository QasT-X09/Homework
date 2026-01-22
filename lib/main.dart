import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class Track {
  final String title;
  final String artist;
  final String url;

  Track({required this.title, required this.artist, required this.url});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Music Player',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const PlayerPage(),
    );
  }
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioPlayer _player = AudioPlayer();
  final List<Track> _tracks = [
    Track(
      title: 'SoundHelix Song 1',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    Track(
      title: 'SoundHelix Song 2',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
    Track(
      title: 'SoundHelix Song 3',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    ),
  ];

  int? _currentIndex;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Listen to position and duration
    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });
    _player.durationStream.listen((d) {
      setState(() => _duration = d ?? Duration.zero);
    });
    _player.playerStateStream.listen((state) {
      // update UI when playback completes
      if (state.processingState == ProcessingState.completed) {
        // play next
        _playNext();
      }
    });
  }

  Future<void> _setAndPlay(int index) async {
    final track = _tracks[index];
    try {
      await _player.setUrl(track.url);
      _currentIndex = index;
      await _player.play();
      setState(() {});
    } catch (e) {
      // handle error (e.g., network)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка воспроизведения: $e')),
      );
    }
  }

  Future<void> _playPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      if (_currentIndex == null) {
        await _setAndPlay(0);
      } else {
        await _player.play();
      }
    }
  }

  Future<void> _playNext() async {
    if (_currentIndex == null) return;
    final next = (_currentIndex! + 1) % _tracks.length;
    await _setAndPlay(next);
  }

  Future<void> _playPrev() async {
    if (_currentIndex == null) return;
    final prev = (_currentIndex! - 1) < 0 ? _tracks.length - 1 : _currentIndex! - 1;
    await _setAndPlay(prev);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final minutes = two(d.inMinutes.remainder(60));
    final seconds = two(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentIndex != null ? _tracks[_currentIndex!] : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Mini Music Player')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                final t = _tracks[index];
                final selected = _currentIndex == index;
                return ListTile(
                  leading: Icon(selected ? Icons.music_note : Icons.queue_music),
                  title: Text(t.title),
                  subtitle: Text(t.artist),
                  trailing: IconButton(
                    icon: Icon(selected && _player.playing ? Icons.pause : Icons.play_arrow),
                    onPressed: () => _setAndPlay(index),
                  ),
                  onTap: () => _setAndPlay(index),
                );
              },
            ),
          ),
          // Mini player
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.audiotrack, size: 40),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(current?.title ?? 'Не выбрано', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(current?.artist ?? '', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: _playPrev,
                    ),
                    StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snapshot) {
                        final playing = _player.playing;
                        return IconButton(
                          iconSize: 32,
                          icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_filled),
                          onPressed: _playPause,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: _playNext,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(_formatDuration(_position)),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1.0,
                        value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble(),
                        onChanged: (value) async {
                          final newPos = Duration(milliseconds: value.toInt());
                          await _player.seek(newPos);
                        },
                      ),
                    ),
                    Text(_formatDuration(_duration)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
