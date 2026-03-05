# Product Catalog

A **senior-level Flutter** product catalog app built as a technical assessment. It features a custom design system, clean architecture, responsive master–detail layout, and production-oriented patterns (error handling, testing, documentation).

---

## Tech Stack

| Area | Choice |
|------|--------|
| **Framework** | Flutter 3.x (stable), Dart 3 |
| **State** | Provider (ChangeNotifier) |
| **DI** | GetIt |
| **Navigation** | GoRouter (deep linking, type-safe routes) |
| **HTTP** | Dio (with logging) |
| **Images** | CachedNetworkImage |
| **Errors** | dartz `Either<Failure, T>` |
| **Models** | Manual JSON parsing with validation (freezed/json_annotation available) |

---

## Architecture

### Overview

The app follows **feature-based Clean Architecture**:

- **Domain** – Entities and repository interfaces; no Flutter/Dio.
- **Data** – Remote data sources (Dio), repository implementations, mapping to domain.
- **Presentation** – Notifiers (state), views (screens), and feature-specific widgets.

Dependencies point inward: presentation → domain ← data. The UI never imports data sources directly; it uses the repository abstraction.

### Layout

```
lib/
├── app/                    # Root app, router config
├── core/                    # Cross-cutting
│   ├── di/                  # GetIt setup (Dio, GoRouter, repos)
│   ├── env/                 # Base URL, config
│   ├── layout/              # Breakpoints (e.g. tablet 768px)
│   ├── network/             # Failure type for Either
│   └── theme/               # AppTheme, ThemeController
├── design_system/           # Shared UI building blocks
│   └── widgets/             # AppButton, AppText, AppCard, ProductCard,
│                            # SearchBar, CategoryChip, LoadingSkeleton,
│                            # ErrorState, EmptyState, ImagePlaceholder,
│                            # PaginationLoader
└── features/
    └── products/
        ├── data/
        │   ├── datasource/           # products_remote.dart
        │   │   └── repository/      # products_repo_impl.dart
        │   └── domain/
        │       ├── entity/           # Product, ProductListResponse
        │       └── repository/       # products_repo.dart (interface)
        └── presentation/
            ├── notifier/             # ProductsNotifier, ProductListState
            ├── view/                 # CatalogPage, ProductDetailPage, MasterDetailShell
            └── widgets/              # EmptyDetailState
```

### Key design decisions

- **GetIt + Provider**: GetIt for singletons (Dio, GoRouter, repos); Provider for screen-scoped notifiers (e.g. `ProductsNotifier` per catalog, `ThemeController` at root). Avoids circular dependency (router receives `ProductsRepo` as a parameter).
- **Either for errors**: Repositories return `Future<Either<Failure, T>>`; notifiers use `.fold()` to handle success/failure and drive UI state (Loading, Loaded, Error, Empty). I decided to use this Either for erros because it makes my code claener and easier to read..

- **Responsive shell**: At ≥768px width, the app shows a master–detail layout (list + detail pane). Below that, it uses stack navigation. Route state (`/products/:id`) drives the selected product so URL and UI stay in sync.


- **Search + category**: When both are set, the app uses the search API and applies category filter client-side (DummyJSON has no combined endpoint). Pagination uses a separate search offset so “load more” requests the next page of search results.

---

## Design rationale

- **Design system**: Reusable components live under `design_system/widgets`. They use `Theme.of(context)` and `ColorScheme` so light/dark and future themes stay consistent. Components are documented and widget-tested.
- **Visual style**: Material 3, custom color schemes (indigo primary, green secondary), soft gradients and shadows, rounded corners. Empty and error states use cards and clear copy; the pagination loader uses a small animated dot indicator instead of a plain bar.
- **UX**: Debounced search, pull-to-refresh, infinite scroll with a clear “load more” indicator, image gallery on detail with page indicator and “Swipe to see more,” category chips with All + API categories. Tablet: split view with empty detail state when nothing is selected.
- **Accessibility**: Semantic structure, contrast via ColorScheme, scalable text. No custom font bundle in the default setup (theme references a family; fallback is platform default).

---

## AI usage

This project was developed with AI assistance (Cursor/LLM) for:

- Implementing phases from a written specification (foundation, design system, data layer, state, list/detail screens, responsive shell, tests, documentation).
- Boilerplate and repetitive code (entity parsing, repository wiring, widget structure).
- Refactors (e.g. switching from Riverpod to GetIt+Provider,Yeah, I started with Riverpod, and then made a switch to Provider.. adding Either/dartz, fixing category parsing when API returned objects instead of strings).
- README and in-code documentation. Documentation reviewed by me. 
- Unit tests

Human decisions included: overall architecture, dependency choices (Provider, GetIt, dartz), API and UI behaviour (search + category, master–detail), and design priorities (simplicity, clarity, senior-level quality).

---

## Limitations

- **No offline cache**: All product data is fetched from the API. No persistence layer (e.g. SQLite or local JSON) or “offline first” behaviour.
- **No auth**: The app is read-only; no login or protected routes.
- **API-bound**: DummyJSON is the only backend. Error messages and retries are generic; no API-specific error codes or mapping.
- **Single locale**: No i18n/l10n; all strings are English.
- **Font**: `AppTheme` references `fontFamily: 'SF Pro Display'`; if the font is not bundled, the platform default is used.
- **Tests**: Coverage focuses on domain entities, repository logic, and notifier behaviour. Widget and golden tests exist for design system and key flows; full integration or E2E tests are not included.
--**UI** With more time, I can always make the UI and even the eprience better
---

## Running the app

```bash
flutter pub get
flutter run  
```

Default target: device or simulator. For web (e.g. to test responsive layout):

```bash
flutter run -d chrome
```

- **Theme**: Use the sun/moon icon in the catalog app bar to toggle light/dark.
- **Design system showcase**: Use the palette icon in the app bar, or go to `/showcase`, to see all design system components (typography, buttons, chips, cards, empty/error states, pagination loader).

---

## Tests

```bash
flutter test
```

Tests live under `test/`: design system widgets, product entities, repository and notifier logic, master-detail route parsing, performance (catalog load), and an optional golden for the empty-detail state. Update goldens with:

```bash
flutter test test/design_system/golden/empty_detail_state_golden_test.dart --update-goldens
```

---

## Phases (summary)

| Phase | Description |
|-------|-------------|
| 1 | Project foundation, lint, theme, GetIt+Provider, GoRouter |
| 2 | Design system (buttons, text, cards, search, chips, skeletons, empty/error, image placeholder) |
| 3 | Data layer (Dio, Product models, repo, pagination/search/category, Either) |
| 4 | State (ProductsNotifier, sealed states, debounce, scroll preservation) |
| 5 | Product list (infinite scroll, pull-to-refresh, animations, navigation) |
| 6 | Product detail (gallery, hero, price/discount, rating, stock, deep link) |
| 7 | Responsive master–detail (tablet split view, empty detail state, state sync) |
| 8 | Testing and quality (unit, widget, optional golden, performance) |
| 9 | Documentation (this README) |
| 10 | Polish: **Showcase** screen (`/showcase`) for design system; **theme toggle** in app bar (catalog + showcase); **AnimatedTheme** (280ms) for light/dark switch; **ThemeController.toggle()** fix |

---

## License

Private / assessment project; not for redistribution without permission.
git add README.md