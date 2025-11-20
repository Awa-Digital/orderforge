# OrderForge

A **core commerce ordering engine** built with Ruby on Rails 8 — a platform-agnostic backend that powers customer onboarding, catalogue and product management, inventory management, order lifecycle management, automated email workflows, vendor operations, administrative tooling, and multiple payment gateway integrations.

OrderForge is designed to be deployed as the engine behind any multi-location commerce brand. Configure branding, domains, and integrations via environment variables without forking core business logic.

Maintained by [Awa Digital](https://awadigital.co).

## Architecture

```
packs/
├── shared/          # OAuth identities, shared services
├── catalog/         # Franchise page visits, catalogue extensions
├── ordering/        # Order state machines, snapshots
├── payments/        # Payment AASM, Stripe processing
├── notifications/   # Unified multi-channel notification pipeline
└── wallets/         # Franchise wallet & payout automation

app/
├── controllers/api/v1/          # Customer & mobile API
├── controllers/api/v2/be/       # Business admin & franchise APIs
├── graphql/                     # GraphQL API
├── admin/                       # ActiveAdmin operational console
├── services/franchise_analytics # Vendor analytics API
└── services/stripe/             # Stripe HTTP client
```

### Platform domains

| Domain | Capabilities |
|--------|-------------|
| **Customer onboarding** | Signup, email/phone OTP, password reset, JWT auth, **OAuth (Google, Apple)** |
| **Catalogue & products** | Categories, subcategories, ingredients, combos, favourites, franchise pricing |
| **Inventory management** | Inventories, stock levels, product BOM, per-franchise quantity tracking |
| **Order lifecycle** | **AASM state machine**, **order snapshots** (price freeze), fulfillment pipeline |
| **Email workflows** | SendGrid + SMTP mailers; **unified notification pipeline** (in-app, push, email) |
| **Vendor operations** | Multi-franchise model, **franchise wallets**, payout automation, staff APIs |
| **Admin tooling** | ActiveAdmin resources, Sidekiq dashboard, GraphQL |
| **Payments** | Paystack, Flutterwave, **Stripe**, vouchers, webhooks |
| **Analytics** | **Franchise analytics API** (summary, timeseries, top products, visit tracking) |
| **Affiliates** | Influencer program, commission tracking, withdrawals |

### API surfaces

| Surface | Path | Purpose |
|---------|------|---------|
| Customer API | `/api/v1/` | Mobile/web customer app |
| OAuth | `POST /api/v1/auth/oauth/token_sign_in` | Google / Apple sign-in |
| Notifications | `/api/v1/notifications` | In-app notification inbox |
| Stripe webhooks | `POST /api/v1/payment/stripe/webhook` | Stripe payment events |
| Business Admin API | `/api/v2/be/admin/` | Back-office operations |
| Franchise API | `/api/v2/be/franchise/:id/` | Wallet, analytics, ops |
| GraphQL | `/graphql` | Flexible admin & integration queries |
| ActiveAdmin | `/admin` | Internal ops console (when `ADMIN_APP=true`) |

## Quick start

### Prerequisites

- Ruby 3.2+
- PostgreSQL
- Redis (for Sidekiq)
- Node.js & Yarn (for ActiveAdmin assets)

### Installation

```bash
git clone https://github.com/Awa-Digital/orderforge-engine.git
cd orderforge-engine

bundle install
yarn install

cp .env.example .env
rails db:create db:migrate db:seed
bin/dev
```

### Branding configuration

```bash
APP_NAME="Your Brand"
APP_URL="https://yourbrand.com"
API_HOST="api.yourbrand.com"
MEDIA_PREFIX="yourbrand"
CORS_ORIGINS="https://app.yourbrand.com"
```

## Tech stack

| Layer | Technology |
|-------|------------|
| Framework | Rails 8, Ruby 3.2 |
| Modularity | Packwerk feature packs |
| State machines | AASM (orders & payments) |
| Payments | Paystack, Flutterwave, Stripe |
| Auth | JWT, OAuth (Google, Apple) |
| Jobs | Sidekiq |
| Monitoring | Sentry (optional) |

## Testing

```bash
bundle exec rspec
bundle exec rspec spec/models/payment_state_machine_spec.rb
bundle exec rspec spec/services/
```

## License

Proprietary — © Awa Digital. Contact [hey@awadigital.co](mailto:hey@awadigital.co) for licensing.
