# OrderForge

A **core commerce ordering engine** built with Ruby on Rails 8 — a platform-agnostic backend that powers customer onboarding, catalogue and product management, inventory management, order lifecycle management, automated email workflows, vendor operations, administrative tooling, and multiple payment gateway integrations.

OrderForge is designed to be deployed as the engine behind any multi-location commerce brand. Configure branding, domains, and integrations via environment variables without forking core business logic.

Maintained by [Awa Digital](https://awadigital.co).

## Architecture

```
app/
├── controllers/
│   ├── api/v1/          # Customer & mobile API
│   └── api/v2/be/       # Business admin & franchise APIs
├── graphql/             # GraphQL API (admin & integrations)
├── admin/               # ActiveAdmin operational console
├── models/              # Domain models
├── services/            # Integration services
├── packages/            # Feature packages (Firebase, SendGrid, Slack, Receipt)
├── mailers/             # Transactional email workflows
└── sidekiq/             # Background jobs
```

### Platform domains

| Domain | Capabilities |
|--------|-------------|
| **Customer onboarding** | Signup, email/phone OTP verification, password reset, JWT auth, user profiles & addresses |
| **Catalogue & products** | Categories, subcategories, ingredients, combos, favourites, hot deals, franchise-specific pricing |
| **Inventory management** | Inventories, stock levels, product BOM, per-franchise quantity tracking |
| **Order lifecycle** | Cart → payment → fulfillment pipeline with status notifications and PDF receipts |
| **Email workflows** | SendGrid + SMTP mailers for orders, OTP, affiliates, reports; configurable sender personas |
| **Vendor operations** | Multi-franchise model, staff & departments, franchise inventory APIs |
| **Admin tooling** | ActiveAdmin resources, Sidekiq dashboard, GraphQL + GraphiQL (dev) |
| **Payments** | Paystack, Flutterwave, vouchers/discounts, webhooks, payment verification |
| **Affiliates** | Influencer program, commission tracking, affiliate links, withdrawals |

### API surfaces

| Surface | Path | Purpose |
|---------|------|---------|
| Customer API | `/api/v1/` | Mobile/web customer app |
| Business Admin API | `/api/v2/be/admin/` | Back-office operations |
| Franchise API | `/api/v2/be/franchise/` | Location-level operations |
| GraphQL | `/graphql` | Flexible admin & integration queries |
| ActiveAdmin | `/admin` | Internal ops console (when `ADMIN_APP=true`) |
| Sidekiq | `/sidekiq` | Job queue monitoring |

## Quick start

### Prerequisites

- Ruby 3.2+
- PostgreSQL
- Redis (for Sidekiq)
- Node.js & Yarn (for ActiveAdmin assets)

### Installation

```bash
git clone https://github.com/Awa-Digital/orderforge.git
cd orderforge

bundle install
yarn install

cp .env.example .env
# Edit .env with your credentials and branding

rails db:create db:migrate db:seed
bin/dev   # or: rails server
```

### Branding configuration

All tenant-specific branding is driven by environment variables (see `.env.example`):

```bash
APP_NAME="Your Brand"
APP_URL="https://yourbrand.com"
API_HOST="api.yourbrand.com"
MEDIA_PREFIX="yourbrand"
CORS_ORIGINS="https://app.yourbrand.com,https://admin.yourbrand.com"
```

## Tech stack

| Layer | Technology |
|-------|------------|
| Framework | Rails 8, Ruby 3.2 |
| Database | PostgreSQL |
| API | JSON REST + GraphQL |
| Auth | Devise (admin), JWT, BCrypt |
| Jobs | Sidekiq + sidekiq-scheduler |
| Payments | Paystack, Flutterwave |
| Email | SendGrid, SMTP |
| SMS | Termii |
| Push | Firebase FCM |
| Storage | CarrierWave + S3-compatible (DigitalOcean Spaces) |
| Admin | ActiveAdmin 4, CanCanCan |
| PDF | Prawn (receipts) |
| Monitoring | Sentry (optional) |

## Secrets & security

**Never commit credentials.** This repository uses environment variables for all secrets.

1. Copy `.env.example` → `.env` for local development
2. Copy `config/cloudinary.yml.example` → `config/cloudinary.yml` if using Cloudinary
3. Copy `config/firebase-credentials.json.example` and set `FIREBASE_CREDENTIALS` path
4. Use `RAILS_MASTER_KEY` + `config/credentials.yml.enc` for production

Files gitignored by default: `.env`, `config/master.key`, `config/cloudinary.yml`, `config/firebase-credentials.json`.

## Background jobs

| Job | Schedule | Purpose |
|-----|----------|---------|
| `ClearAbandonedCartTaskJob` | Daily | Remove stale cart orders |
| `ReportTaskJob` | Configurable | Generate operational reports |
| `SendMarketingSmsJob` | On demand | Marketing SMS campaigns |

## Development

```bash
# Run tests
bundle exec rspec

# Start with CSS watchers
bin/dev

# Enable admin panel + Sidekiq UI
ADMIN_APP=true rails server
```

## License

Proprietary — © Awa Digital. Contact [hey@awadigital.co](mailto:hey@awadigital.co) for licensing.

## Contributing

This is the core engine repository. Brand-specific deployments should fork or deploy OrderForge with environment configuration rather than modifying core domain logic.
