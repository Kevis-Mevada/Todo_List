# 📝 Todo List App (Flutter)

A mobile application for task management built with Flutter. It features secure user authentication and instant data synchronization using Firebase, allowing for real-time updates across devices.

This project was built as part of my mobile development learning path.

---

## ✨ Key Features

* **Secure Authentication:** Users can sign up and log in using Firebase Authentication.
* **Real-time Database:** Tasks are synced instantly across devices using Firebase Realtime Database.
* **Add Tasks:** Easily add new tasks to your list.
* **Complete Tasks:** Mark tasks as 'complete' with a simple tap.
* **Clean UI:** A simple and clean user interface for managing daily tasks.

## 💻 Technology Stack

* **Frontend:** Flutter (Dart)
* **Backend:** Firebase
* **Services:**
    * Firebase Authentication
    * Firebase Realtime Database

## 🖼️ Screenshots
(Images from the `Project images` folder)

| Login Screen | Home Screen |
| :---: | :---: |
| <img src="Project images/Login.jpg" width="250"> | <img src="Project images/Home.jpg" width="250"> |

| Add New Task | Task Completed |
| :---: | :---: |
| <img src="Project images/Add.jpg" width="250"> | <img src="Project images/Tick task.jpg" width="250"> |

## 🚀 How to Run Locally

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/Kevis-Mevada/Todo_List.git](https://github.com/Kevis-Mevada/Todo_List.git)
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd Todo_List
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Setup Firebase:**
    * Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
    * Add an "Android" app to your Firebase project.
    * Follow the setup steps and download the `google-services.json` file.
    * Place this file inside the `android/app/` directory.
5.  **Run the app:**
    ```bash
    flutter run
    ```
