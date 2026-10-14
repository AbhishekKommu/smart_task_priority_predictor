# Smart Task Priority Predictor

A Flutter app that predicts the priority (High / Medium / Low) of each task from its
deadline, importance and estimated effort, and reminds you with a **sound alarm** so you
never forget a task.

## Features
- Add tasks with deadline, importance (1-5), effort (hours) and an optional reminder time
- On-device priority prediction (score 0-100), tasks sorted automatically
- Sound reminder: looping alarm + dialog while the app is open (web/mobile), scheduled
  notification with sound on Android/iOS when the app is closed
- Beautiful gradient background with glass-style cards, light and dark mode
- Analytics and progress cards, local storage (shared_preferences)

## Setup
The `android/` folder is a placeholder. Generate the native files once:

```bash
flutter create . --project-name smart_task_priority_predictor --platforms=android,web
flutter pub get
```
Then follow `android/ANDROID_SETUP.md` (notification permissions + desugaring).

```bash
flutter run -d chrome   # web
flutter run             # Android
```

## Tests
```bash
flutter test
```

## Build for web and deploy on Render
```bash
flutter build web --release
rm -rf site && mkdir site && cp -r build/web/* site/
```
On Render create a **Static Site**, connect the repo and set **Publish directory** to `site`.

Or with Docker (`Dockerfile` + `nginx.conf`):
```bash
docker build -t task-priority .
docker run -p 8080:80 task-priority
```

## Notes
- Web: the alarm only plays while the browser tab is open (browser limitation).
- Android battery saver may delay notifications by a few minutes.
- Replace `assets/sounds/alarm.wav` with your own sound if you like.

## Project structure
```
lib/models     task_model.dart
lib/screens    home, add task, task details, analytics, settings
lib/services   priority_predictor, storage_service, notification_service
lib/widgets    task_card, priority_badge, progress_card, gradient_background
lib/utils      app_theme.dart
assets/sounds  alarm.wav
test/          predictor + widget tests
```
