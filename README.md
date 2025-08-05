This project was created as part of a take-home assignment, but is also structured as a clean, scalable portfolio piece showcasing backend fundamentals, API design, and performance awareness.

A simple users API built with Ruby on Rails.  
Users can view, create and delete their records. They can also follow other users.

---

## Features

![RSpec Tests](https://img.shields.io/badge/tests-passing-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-100%25-green)

- CRUD for users
- Follow/unfollow other users
- Scalable design with pagination, caching

---

## Tech Stack

- **Ruby on Rails**
- **PostgreSQL**
- **Grape** — lightweight REST API framework
- **Pagy** — pagination
- **Swagger** — auto-generated API docs

---

## Setup Instructions

```bash
# Clone the repo
git git@github.com:anthony-devhub/user-service.git
cd user-service

# Install dependencies
bundle install

# Setup DB
rails db:setup

# Run the server
rails server

```

---

## API Documentation (Swagger)

Here's a preview:

![Swagger Preview](docs/user-service.gif)

---

## Performance Notes

- **Indexing**: Appropriate DB indexes are in place for queries.

- **Caching**: Follower feed results are cached per user (Rails.cache) with 5-minute expiry to reduce expensive DB aggregation.

- **Pagination**: Limits and offsets are applied to queries via params (page, limit) for scalability.

- **pg_trgm**: for fuzzy search with ILIKE

---

## Author

**Anthony Salim**

Senior Ruby on Rails Backend Developer

🇮🇩 Indonesia | 🌐 Open to remote roles.

Let’s build something cool together!

📧 anthonysalim.dev@gmail.com