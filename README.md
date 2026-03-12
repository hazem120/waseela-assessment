## Project Setup

**Flutter:** 3.41.4 (stable)

**Tested platform:**   IOS

**Node.js:** v20.13.1

Mock APIs are used to simulate backend responses.
Note: The free API service plan allows a **maximum of two endpoints**, so i've used made a small express application to implement the required endpoints.

Start the mock server:

repo: https://github.com/hazem120/waseela-mock-api 

```
$npm install 

$npm start dev
```
---

## State Management

**Riverpod** is used for state management.

**Reason:** Riverpod was chosen because it provides **Simpler setup, better readability, and simpler dependency management** compared to BLoC, while still being scalable for this project.

---

## Architecture Overview (Clean Architecture)

This project follows a lightweight **Clean Architecture** approach with clear separation between **core** utilities and the **BNPL feature**.

- **Core (`lib/core/`)**
  - **`network/`**: Dio client setup (`ApiClient`) used by repositories.
  - **`utils/`**: shared constants + theme helpers.

- **BNPL feature (`lib/features/bnpl/`)**
  - **`repository/`**: `BnplRepository` is the single data access layer for the mock REST API (returns JSON or `null`, logs errors).
  - **`usecases/`**: small business actions that are easy to unit test (example: `GetPlansUseCase`).
  - **`providers/`**: Riverpod `Notifier` (`BnplNotifier`) + state (`BnplState`) for UI state and async loading.
  - **`views/` / `screens/`**: UI screens (Checkout → Plan selection → Confirmation) consuming the providers.

- **Tests (`test/`)**
  - Includes unit tests for **one use case** and **one notifier**, plus a widget test for **Checkout screen**.
- CI pipeline
