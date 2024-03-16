<h1 align="center">WhatsUp</h1>
<p align="center">
  <img src="assets/img/whatsup.jpg" width="400" alt="WhatsUp"  >
</p>
<p align="center">
WhatsUp aims to replicate some of the WhatsApp core features but its main purpose is to showcase how easy it is to build real-time applications with Flutter and Firebase. 
</p>

## Features

- Phone Authentication 📲: Users can register their phone number and receive an OTP (One-Time Password) for verification.
- Light / Dark Theme 🌞🌚: You can switch between light and dark theme after you registered.
- Contacts Display 📒: Users can see their contacts who are already using the app.
- Real-time messaging 💬 ⚡: Clients can communicate each other in real time.
- Chat features 💬📷🎙️: Clients can send and receive text , images, videos and voice messages.
- Online / Offline Status 🟢🔴: Clients can see other users online or offline status.
- Read / Unread Messages ☑️👀: Clients can see if other users have read their messages.
- Message Replies ↩️: You can reply to specific messages in a conversation, facilitating threaded discussions.
- Emoji Support 😉: Users can send emojis in their messages using a built-in emoji picker.
- Group Chat 👥: Users can create groups and select the members.
- Status / Stories 📷🪩: Users can post status updates and view the status of other users.
- Video calls 📹🤳: Users can make video calls to their contacts.
- Call History 📞: Users can see their call history, who they called and who called them.
- Real-time updates ⚡: All of the above features are updated in real-time as they happen, and synced across devices.

## Screenshots

Here are some screenshots of the app.

|                Splash Screen                 |                Phone Authentication                 |                 OTP Verification                  |
| :------------------------------------------: | :-------------------------------------------------: | :-----------------------------------------------: |
| ![Welcome Screen](assets/readme/welcome.png) | ![Phone Authentication](assets/readme/send_sms.png) | ![OTP Verification](assets/readme/verify_sms.png) |

|                   Create Profile                    |               Chats               |              Chats Light Theme               |
| :-------------------------------------------------: | :-------------------------------: | :------------------------------------------: |
| ![Create Profile](assets/readme/create_profile.png) | ![Chats](assets/readme/chats.png) | ![Chats Dark](assets/readme/chats_light.png) |

|              Chat               |                 Chat Reply                  |              Chat Light Theme               |
| :-----------------------------: | :-----------------------------------------: | :-----------------------------------------: |
| ![Chat](assets/readme/chat.png) | ![Chat Reply](assets/readme/chat_reply.png) | ![Chat Light](assets/readme/chat_light.png) |

|                  Create Group                   |                     Create Group Light                      |                  Status Page                   |
| :---------------------------------------------: | :---------------------------------------------------------: | :--------------------------------------------: |
| ![Create Group](assets/readme/create_group.png) | ![Create Group Light](assets/readme/create_group_light.png) | ![Status Page](assets/readme/status_empty.png) |

|                   Status Writer                   |                   Status Viewer                   |                        Status Updates                        |
| :-----------------------------------------------: | :-----------------------------------------------: | :----------------------------------------------------------: |
| ![Status Writer](assets/readme/status_writer.png) | ![Status Viewer](assets/readme/status_viewer.png) | ![Recent Calls Light Mode](assets/readme/status_updates.png) |

|                  Recent Calls                   |                     Recent Calls Light                      |                   Receiving Calls                    |
| :---------------------------------------------: | :---------------------------------------------------------: | :--------------------------------------------------: |
| ![Recent Calls](assets/readme/recent_calls.png) | ![Recent Calls Light](assets/readme/recent_calls_light.png) | ![Receiving Calls](assets/readme/receiving_call.png) |

## Getting Started

To get started and run the app, you first need to create firebase project to set the required environment variables.

- Create a `.env` file in the root of the project.
- Copy the content of `.env.example` to `.env` and fill the required fields.

I recommend using both firebase and flutterfire CLI tools to configure firebase: https://firebase.google.com/docs/flutter/setup

After running `flutterfire configure`, a generated file `firebase_options.dart` will be created in the `lib` folder.
This file will contain the required environment variables from your firebase project for the app to work.

Once everything is set up, you can `flutter run` the app. If you don't get any exception while loading the app, you are good to go.

### Firebase Configuration

Before you can use any feature of the app, you need to configure the Firebase project.

- **Authentication**: Enable Phone Authentication.
  - **Important:** You need to add your (test) phone number and the verification code to the Firebase Console to be able to register
    and login with your phone number.
- **Firestore Database**: Create a Firestore database and set the rules to allow read and write access to all users.
- **Cloud Store**: Create a Cloud Store and set the rules to allow read and write access to all users.
