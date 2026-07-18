<div align="center">

<br/>

```
███████╗██╗   ██╗██████╗ ███████╗ ██████╗
██╔════╝██║   ██║██╔══██╗██╔════╝██╔═══██╗
███████╗██║   ██║██████╔╝███████╗██║   ██║
╚════██║██║   ██║██╔══██╗╚════██║██║   ██║
███████║╚██████╔╝██║  ██║███████║╚██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝
```

### Mobile App — SURSO Event Management Platform

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-F59E0B?style=for-the-badge)](LICENSE)

<br/>

</div>

## 🌟 Overview

This is the **Flutter mobile client** for SURSO, an open-source event management platform. It mirrors the web app's core flows — browsing and registering for events, downloading QR-coded tickets, and organizer/admin tools like real-time QR check-in — as a native Android/iOS app.

SURSO is split across three repositories:

- [SURSO-backend](https://github.com/Giannossk/SURSO-backend) — Express + MongoDB REST API
- [SURSO-frontend](https://github.com/Giannossk/SURSO-frontend) — React + Vite web client
- **[SURSO-mobile](https://github.com/Giannossk/SURSO-mobile)** — this repo

This app talks to [SURSO-backend](https://github.com/Giannossk/SURSO-backend) over HTTP + Socket.IO — you'll need it running locally (or deployed) to use most features.

<br/>

## 🛠 Tech Stack

| | Technology | Purpose |
|---|---|---|
| <img src="https://skillicons.dev/icons?i=flutter" width="30"/> | **Flutter / Dart** | Cross-platform app framework |
| <img src="https://img.shields.io/badge/Riverpod-1B1B1F?style=flat&logoColor=white" height="24"/> | **flutter_riverpod** | State management |
| <img src="https://img.shields.io/badge/go__router-02569B?style=flat&logoColor=white" height="24"/> | **go_router** | Navigation |
| <img src="https://img.shields.io/badge/Dio-0175C2?style=flat&logoColor=white" height="24"/> | **dio** | HTTP client |
| <img src="https://skillicons.dev/icons?i=socketio" width="30"/> | **socket_io_client** | Real-time events (check-ins, live stats) |
| <img src="https://img.shields.io/badge/mobile__scanner-4285F4?style=flat&logoColor=white" height="24"/> | **mobile_scanner** | QR code scanning for check-ins |
| <img src="https://img.shields.io/badge/pdf%20%2B%20printing-D32F2F?style=flat&logoColor=white" height="24"/> | **pdf / printing / share_plus** | Ticket generation & sharing |

<br/>

## 📁 Project Structure

```
lib/
├── core/        # App-wide config, theming, constants
├── data/        # API clients, repositories
├── features/    # Feature modules (events, auth, check-in, etc.)
├── models/      # Data models
├── shared/      # Shared widgets/utilities
└── main.dart
```

<br/>

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (see `environment.sdk` in `pubspec.yaml` for the required version)
- A running instance of [SURSO-backend](https://github.com/Giannossk/SURSO-backend) (local or deployed)
- Android Studio / Xcode for platform builds, or a device/emulator

### 1. Clone & Install

```bash
git clone https://github.com/Giannossk/SURSO-mobile.git
cd SURSO-mobile
flutter pub get
```

### 2. Configure the API endpoint

Point the app at your running [SURSO-backend](https://github.com/Giannossk/SURSO-backend) instance — check `lib/core/` for the base URL configuration used by the `dio` client.

### 3. Run

```bash
flutter run
```

<br/>

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.
