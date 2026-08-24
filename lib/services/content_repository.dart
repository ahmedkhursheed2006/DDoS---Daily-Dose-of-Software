import 'package:flutter/services.dart';

class ContentRepository {
  static const _files = [
    'day-01-dns-prefetching.md',
    'day-02-udp-lossy-transmission.md',
    'day-03-latency-physical-distance.md',
    'day-04-reverse-proxies-network-hops.md',
    'day-05-dns-point-of-failure.md',
    'day-06-ddos-attacks.md',
    'day-07-heartbeats-keepalive.md',
    'day-08-http-range-requests.md',
    'day-09-rate-limiting.md',
    'day-10-browser-compatibility.md',
    'day-11-event-driven-io.md',
    'day-12-offline-first-design.md',
    'day-13-adaptive-bitrate-streaming.md',
    'day-14-cookies-shared-storage.md',
    'day-15-bgp-misconfiguration.md',
    'day-16-optimistic-ui.md',
    'day-17-clock-drift.md',
    'day-18-beforeunload-events.md',
    'day-19-idempotent-api-design.md',
    'day-20-request-waterfalls.md',
    'day-21-rendering-pipeline.md',
    'day-22-javascript-hydration.md',
    'day-23-unnecessary-rerenders.md',
    'day-24-persistent-client-storage.md',
    'day-25-layout-reflow-box-model.md',
    'day-26-extension-permissions.md',
    'day-27-viewport-dpi-responsive-units.md',
    'day-28-lazy-loading-intersection-observer.md',
    'day-29-bfcache.md',
    'day-30-service-workers-pwa.md',
    'day-31-client-side-restrictions.md',
    'day-32-compositor-thread.md',
  ];

  static Future<List<Map<String, dynamic>>> loadPosts() async {
    final posts = <Map<String, dynamic>>[];
    for (var index = 0; index < _files.length; index++) {
      final filename = _files[index];
      final markdown = await rootBundle.loadString('lib/content/$filename');
      final title = RegExp(r'^#\s+(.+)$', multiLine: true).firstMatch(markdown)?.group(1) ?? filename;
      posts.add({
        'id': filename,
        'seriesId': 'local-daily-dose',
        'seriesTitle': 'Daily Dose of Software',
        'title': title,
        'content': markdown,
        'sourceReference': 'lib/content/$filename',
        'positionInSeries': index + 1,
        'readTimeMinutes': 5,
      });
    }
    return posts;
  }

  static Future<Map<String, dynamic>> loadPost(String id) async {
    final posts = await loadPosts();
    return posts.firstWhere(
      (post) => post['id'] == id,
      orElse: () => posts.first,
    );
  }
}
