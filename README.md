# Plant Care Reminder App

**Author:** Abhinav Singh  
**Date:** December 08, 2024

---

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Usage](#usage)
- [Configuration](#configuration)
- [Testing](#testing)

---

## Introduction

The **Plant Care Reminder App** is designed to assist both indoor and outdoor plant enthusiasts in managing their plant collections effectively. By providing customized care schedules, real-time weather updates, and personalized care tips based on the user's location, the app ensures that plants remain healthy and thrive with minimal effort from the user.

---

## Features

### **Authentication**
- **Login Screen:**
  - Secure user authentication using email and password.
  - Option to navigate to the registration screen for new users.

- **Register Screen:**
  - Allows new users to create an account by providing their name, email, and password.
  - Ensures password confirmation and validation.

### **Plant Management**
- **My Plants Screen:**
  - Displays a searchable and filterable grid of the user's plants.
  - Supports adding new plants with details like name, species, and location (indoor/outdoor).

- **Add Plant Screen:**
  - Allows users to upload a photo of their plant using the camera.
  - Collects essential plant information such as name, species, light requirements, and watering frequency.

- **Plant Details Screen:**
  - Shows detailed information about each plant, including image, health status, watering schedule, and more.
  - Allows users to water plants directly from the details screen.

### **Weather Integration**
- **Current Weather Widget:**
  - Fetches and displays real-time weather data based on the user's location.
  - Provides watering advice tailored to current weather conditions.

### **Settings**
- **Settings Screen:**
  - **Appearance:** Toggle between light and dark modes.
  - **Units:** Switch between Metric and Imperial measurement systems.
  - **Account Management:** Access profile settings and delete account functionality.
  - **App Information:** View app version and other relevant details.

### **Profile**
- **Profile Screen:**
  - Displays user information, including profile picture, username, and email.
  - Shows plant care statistics like total plants, thriving plants etc.

### **Geolocation**
- **Geolocation:**
  - Provides location-based plant care tips and weather considerations to optimize plant health.


### **User Experience Enhancements**
- **Gesture Controls:**
  - Swipe right to view plant details.
  - Swipe left for quick actions.
  - Pull down to refresh data.
  - Double tap to quickly water a plant.

---

## Technology Stack

- **Programming Language:** Dart
- **Framework:** Flutter
- **State Management:** Provider
- **Backend Services:** Firebase (Authentication, Firestore, Storage)
- **Packages/Plugins:**
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `provider`
  - `geolocator`
  - `shared_preferences`
  - `weather`
  - `intl`
  - `flutter_test` 

---

## Configuration

### APIs Used :
- **OpenweatherMap** 
- **Perenual**

---

## Testing 

- **Unit Tests :**
- **Integration Tests :**
- **Widgets Tests :**


