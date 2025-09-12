Mini Social Feed

Welcome to Mini Social Feed — a Flutter demo app that feels a lot like scrolling Instagram or Twitter. You’ll find posts with photos and videos, smooth infinite scroll, likes & comments that update instantly, a profile page when you tap an avatar, and even a dark/light mode toggle. It also works offline thanks to local caching.

Getting Started

Check Flutter
Make sure you have Flutter 3.22+ installed:

flutter --version

Clone the project and create platform folders:

flutter create .

Install dependencies:

flutter pub get

Android setup:

In android/app/src/main/AndroidManifest.xml add:

<uses-permission android:name="android.permission.INTERNET"/>

Keep minSdkVersion 21 and targetSdkVersion 34.

Run it:

flutter run -d emulator-5554 # Android
flutter run -d "iPhone 15 Pro" # iOS
flutter run -d chrome --web-renderer html # Web

Tip: On the web, always use --web-renderer html so videos play nicely.

How It’s Built

This project follows Clean Architecture with BLoC — but in plain words:

UI Layer → Flutter widgets (screens, buttons, lists).

BLoC Layer → Handles “what happens when” (fetch posts, toggle like, refresh feed).

Domain Layer → Defines what a Post or User is, and the actions (use cases).

Data Layer → Talks to APIs (JSONPlaceholder, Picsum, sample video URLs) and local cache (Hive).

Think of it as:
UI asks → BLoC decides → Domain defines → Data delivers.

Key Features

Infinite scrolling feed (loads more posts when you hit the bottom).

Photos (from Picsum
) and videos (sample MP4s).

Likes toggle instantly, even offline (Hive cache).

Comments open in a bottom sheet (mocked data).

Profile page when you tap avatar/username (shows user info + their posts).

Dark mode toggle in the app bar (remembers your choice).

Offline ready (cached posts load when you have no network).

Packages We Use

Here’s the toolkit that makes it all work:

flutter_bloc → for state management.

equatable → easy value comparisons.

dio → fast & clean HTTP requests.

go_router → navigation between feed and profile.

hive / hive_flutter → lightweight offline storage.

cached_network_image → auto-caches images.

video_player + visibility_detector → autoplay/pause videos as you scroll.

connectivity_plus → detect online/offline mode.

timeago → “5m ago” timestamps.
