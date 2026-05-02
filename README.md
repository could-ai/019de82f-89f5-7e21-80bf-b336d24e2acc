# Clinic Management App

A Flutter-based desktop/tablet application for managing patient registrations and clinic billing.

## Features

*   **Patient Registration:**
    *   Register new patients with Name, Date of Birth, NIC/Passport, and Contact Number.
    *   Duplicate checking based on NIC and Contact Number.
    *   Auto-generation of unique Patient IDs.
*   **Billing & Invoicing:**
    *   Select patients from the database.
    *   Add available services to the invoice.
    *   Calculate subtotals, applying discounts and automatically calculating 10% tax.
    *   Generate uniquely identified invoices/receipts.
*   **Audit & Ledger:**
    *   View all registered patients.
    *   View all generated invoices and their totals.
*   **Navigation:**
    *   Persistent Navigation Rail for easy switching between Registration, Billing, and Ledger modules.

## Tech Stack

*   Flutter (Cross-platform UI toolkit)
*   Dart (Programming language)
*   In-memory Mock Database (for state management and demonstration)

## Setup and Run

1.  Ensure you have [Flutter](https://flutter.dev/docs/get-started/install) installed.
2.  Clone this repository.
3.  Run `flutter pub get` to install dependencies.
4.  Run `flutter run` to launch the app. Use a tablet or desktop target (e.g., macOS, Windows, Chrome) for the best UI experience with the Navigation Rail.

---

## About CouldAI

This app was generated with [CouldAI](https://could.ai), an AI app builder for cross-platform apps that turns prompts into real native iOS, Android, Web, and Desktop apps with autonomous AI agents that architect, build, test, deploy, and iterate production-ready applications.
