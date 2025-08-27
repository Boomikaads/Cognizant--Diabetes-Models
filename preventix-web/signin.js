// signin.js
import { auth, db } from "./firebase-config.js";
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword
} from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";
import {
  doc, setDoc
} from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";

const emailInput = document.getElementById("email");
const passwordInput = document.getElementById("password");
const message = document.getElementById("message");

document.getElementById("loginBtn").addEventListener("click", async () => {
  const email = emailInput.value;
  const password = passwordInput.value;

  try {
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    message.style.color = "green";
    message.textContent = "Login successful! Redirecting...";
    setTimeout(() => {
      window.location.href = "start-prediction.html";
    }, 1000);
  } catch (error) {
    message.textContent = "Login failed: " + error.message;
  }
});

document.getElementById("signupBtn").addEventListener("click", async () => {
  const email = emailInput.value;
  const password = passwordInput.value;

  try {
    const userCredential = await createUserWithEmailAndPassword(auth, email, password);

    // Create a Firestore document for this doctor
    await setDoc(doc(db, "doctors", userCredential.user.uid), {
      email: email,
      createdAt: new Date().toISOString()
    });

    message.style.color = "green";
    message.textContent = "Signup successful! Redirecting...";
    setTimeout(() => {
      window.location.href = "start-prediction.html";
    }, 1000);
  } catch (error) {
    message.textContent = "Signup failed: " + error.message;
  }
});
