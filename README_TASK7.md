# Task 7: Connecting the App Together

## What This Task Was About

We connected the app (built with Flutter) to the backend server (built with Node.js) and the database (PostgreSQL). This means users can now sign up, log in, and move between screens smoothly.

---

## What We Did

1. **Login & Sign Up Work Now**
   The Login and Sign Up screens are connected to the server. When a user logs in or signs up successfully, they are automatically taken to the main app screen.

2. **Database is Organized**
   The database tables (for users, series, posts, and comments) were set up correctly to match what the app expects. Each user now gets a unique ID.

3. **Server Connects Reliably**
   We fixed some connection issues so the server can talk to the database consistently without errors.

4. **App Handles Data Better**
   The app now correctly reads user information from the server, even if the data comes in slightly different formats (like numbers vs. text). This prevents the app from crashing.

---

## How It All Connects

```
   Flutter App  →  Server  →  Database
   (Login/Signup)  (Node.js)  (PostgreSQL)
```

## The app sends login or sign-up info to the server. The server checks the database and sends back a confirmation (plus a login token) so the user can access the app.

## Features Tested

| Feature       | What Happens           | Result                                    |
| ------------- | ---------------------- | ----------------------------------------- |
| Sign Up       | Creates a new account  | ✅ Works                                  |
| Login         | Logs the user in       | ✅ Works                                  |
| Daily Content | Loads featured content | ✅ Works (some content still being added) |

---

## What We Confirmed Works

- ✅ Users can sign up and their info is saved
- ✅ Users can log in successfully
- ✅ Moving between app tabs (Home, Explore, Daily Dose, Progress, Profile) works smoothly
