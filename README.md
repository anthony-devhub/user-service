This project was created as part of a take-home assignment, but is also structured as a clean, scalable portfolio piece showcasing backend fundamentals, API design, and performance awareness.

A simple sleep-tracking API built with Ruby on Rails.  
Users can clock in their sleep time and follow other users to see how well their friends are resting.

---

## Features

- Clock in/out to record sleep sessions
- Follow/unfollow other users
- Retrieve previous week's sleep data from followed users
- Scalable design with pagination, caching, and background jobs

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
git clone git@bitbucket.org:anthony626/test_prep.git
cd test_prep

# Install dependencies
bundle install

# Setup DB
rails db:setup

# Run the server
rails server

```

---

## Performance Notes

- N+1 Avoidance: Preloading is used where applicable (e.g., when loading followed users' records).

- Indexing: Appropriate DB indexes are in place for queries.

- Caching: Follower feed results are cached per user (Rails.cache) with 5-minute expiry to reduce expensive DB aggregation.

- Triggers cache busting on new sleep entry creation or deletion.

- Pagination: Limits and offsets are applied to queries via params (page, limit) for scalability.

- pg_trgm + GIN Index: for fuzzy search with ILIKE

---

## Author

**Anthony Salim**

Senior Ruby on Rails Backend Developer

🇮🇩 Indonesia | 🌐 Open to remote roles.

Let’s build something cool together!

📧 anthonysalim.dev@gmail.com