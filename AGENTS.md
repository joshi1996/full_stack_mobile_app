# Project Instructions — Full-Stack Commerce Platform

## 1. Mission
Build a production-grade, Amazon-scale, multi-vendor commerce learning platform. This is a serious engineering project, not a portfolio demo. Learn and implement scalable backend engineering, distributed systems, databases, security, cloud, DevOps, observability, system design and AI integration through realistic commerce features.

## 2. Repository
- Repository root: C:\dev\full_stack_mobile_app
- Git branch: develop
- Flutter app: frontend/mobile_app/
- NestJS backend: backend/api/
- Keep one Git repository at the root. Never run git init in subdirectories.
- Inspect the real repository state before changing files. Existing code is the source of truth; this document may lag behind.

## 3. Product scope
Build a multi-vendor marketplace with customer, seller and admin capabilities. Domains include authentication, users, catalog, search, cart, pricing, inventory, orders, payments, fulfillment, notifications, CMS, promotions, analytics, recommendations, seller management, fraud/risk, tax/invoices and media.

The customer app should ultimately support:
- Professional, responsive and accessible UI.
- English, Hindi and Gujarati initially; prepare for additional languages and RTL.
- Light, dark and system themes, plus campaign/festival-driven styling.
- CMS-driven home screens and campaigns without requiring an app release.
- Product image galleries, video and zoom.
- Loading, error, empty, offline and retry states.

## 4. Architecture principles
- Start with a modular monolith and explicit domain boundaries. Extract services only when justified.
- Prefer clear separation of presentation, application, domain and infrastructure concerns.
- Flutter: feature-first Clean Architecture, BLoC/Cubit, repositories/use cases, GetIt dependency injection, strong typing, centralized routing and design tokens.
- Backend: NestJS modules, explicit providers, DTO validation, configuration validation, dependency injection and testable domain/application logic.
- PostgreSQL is the transactional source of truth. Redis is for appropriate caching/ephemeral coordination, not a replacement for durable data.
- Use Drizzle ORM and version-controlled migrations. Never change the database schema manually without a migration.
- Store product media in object storage/CDN, not database binary columns.
- Use events/queues for suitable asynchronous work. Design retries, idempotency and concurrency control deliberately.
- AI must access commerce capabilities through validated application APIs/tools, never direct database access.
- Design for security, observability, horizontal scaling, graceful failure, backups and recovery.

## 5. Engineering standards
- Follow existing conventions and installed package versions unless there is a justified reason to change them.
- Inspect relevant files and tests before editing. Prefer small, coherent, end-to-end changes.
- Avoid unnecessary dependencies, speculative abstractions, premature microservices and unrelated refactors.
- Avoid magic strings/numbers where named constants or typed configuration are appropriate.
- Validate input at trust boundaries. Never log secrets or commit credentials.
- Keep .env, node_modules, build output, coverage and local secrets out of Git. Commit .env.example without real credentials.
- Never run destructive commands, delete user data, reset databases, remove volumes or force-push without explicit approval.
- Never run npm audit fix --force or perform broad dependency upgrades without explaining the impact and obtaining approval.
- Do not silently change project architecture, major dependencies, package manager or runtime version.
- Add or update meaningful unit/integration/E2E tests for changed behavior.
- Do not claim a check passed unless it was actually run and its result inspected.

## 6. Workflow for every task
1. Inspect Git status, relevant source files, package scripts and existing tests.
2. Briefly state the intended change and any important assumptions.
3. Implement the smallest complete, maintainable solution.
4. Run appropriate format/lint, build, unit and integration/E2E checks using the project's actual scripts.
5. Diagnose failures and fix regressions introduced by the change; do not hide failures or skip tests to claim success.
6. Summarize files changed, design decisions, commands/results and any remaining risks.
7. Identify the next logical task, but do not start unrelated work.
8. Do not commit or push unless explicitly requested.

## 7. Work efficiently
- Prefer completing a coherent feature or milestone over editing files one by one.
- Do not spend excessive time polishing one screen while core flows remain incomplete.
- Keep explanations concise but explain important architectural decisions and trade-offs.
- Reuse existing code and avoid duplicating functionality.
- Ask questions only when a missing decision blocks safe progress; otherwise inspect the repo and choose a reasonable, reversible default.
- Do not repeat this entire instruction file in responses.

## 8. Current technical context — verify before relying on it
Flutter previously reported version 3.47.2 stable with Dart 3.13.2.
Backend is in backend/api/ and uses NestJS, TypeScript ESM/NodeNext, Jest, @nestjs/config, Joi, PostgreSQL, Drizzle ORM and Redis.
Docker Compose defines PostgreSQL 17 on host port 5434 and Redis 8 on host port 6379. Existing unrelated containers may use other PostgreSQL ports; do not stop them.
Environment variables include NODE_ENV, PORT, DATABASE_URL and REDIS_URL. Local .env must remain untracked.
Drizzle schema directory: src/database/schema/
Migration directory: drizzle/
Database files include src/database/database.module.ts and src/database/database.provider.ts.
The users migration has been generated and applied to the commerce PostgreSQL database.
Previously, npm run build, npm test and npm run test:e2e passed before the latest AppModule registration change. Re-run checks to establish the current state.
The backend was previously using Node 25.2.1, which triggered engine warnings for some tooling. Check current versions and package engine requirements before recommending a runtime change; do not switch versions automatically.
A previous GitHub checkpoint was 3af2311 (feat: add backend foundation) on develop. Verify Git state; do not assume there are no newer changes.

## 9. Immediate priority
Continue the database foundation in backend/api:
- Inspect app.module.ts, database.module.ts, database.provider.ts, env validation, Drizzle configuration and existing tests.
- Confirm DatabaseModule is registered correctly and the provider is exported/injectable.
- Run build, unit tests and E2E tests.
- Verify real PostgreSQL connectivity with a safe, deterministic test or health check; do not mistake successful compilation for successful connectivity.
- Add focused tests for database provider/module behavior where practical, without requiring every unit test to depend on a live database.
- Preserve clean dependency injection and graceful resource shutdown.
- Do not implement unrelated authentication, catalog or order features until this milestone is verified.

## 10. Definition of done
A task is complete only when the implementation matches the existing architecture, relevant checks have been run, failures are reported honestly, secrets remain safe, and the next step is clear.

## 11. Learning Mode
- The user is building this project to become a stronger Senior Engineer, not merely to generate code with AI. Codex implements requested changes; explanations and exercises support the user's learning. Do not ask the user to write or copy code manually.
- Before implementation, provide a concise plan and identify the main concepts the user will learn. Do not repeat the full project context in every task.
- After implementation, explain every changed handwritten code line. Group adjacent lines only when they serve the same purpose. For each change, explain what it does, why it is needed, and how it works.
- Explain execution flow, important language and framework concepts, alternatives and trade-offs, failure modes, security, scalability, and testing implications where relevant.
- Explain generated files and lockfile changes at the file or change level instead of line by line.
- Clearly distinguish verified facts from assumptions. Report actual test results and explain what the tests do not establish.
- Keep explanations structured and token-efficient without omitting meaningful code changes merely for brevity.
- Teach progressively with a few short Socratic questions or practical scenarios after major concepts. When conducting a quiz, wait for the user's answers. Quizzes must not block routine implementation.
