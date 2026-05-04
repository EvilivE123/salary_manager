# Salary Manager

> A high-performance Ruby on Rails application designed to streamline employee data management, track compensation KPIs, and securely administer role-based payroll operations through a dynamic dashboard.

## 🚀 Tech Stack

* **Framework:** Rails 8.1.3
* **Database:** PostgreSQL 16.13 (using Neon for Production)
* **Deployment:** Containerized via "Back4App"

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your local machine:
* Ruby (v3.x or higher)
* PostgreSQL
* Node.js & Yarn (for asset management)

---

## 🛠️ Local Development Setup

Follow these steps to get your development environment running:

**1. Clone the repository**
```bash
git clone https://github.com/EvilivE123/salary_manager.git
cd salary_manager
```

**2. Install dependencies**
```bash
bundle install
yarn install
```

**3. Database Setup**
```bash
rails db:setup 
(Note: You may need to configure your config/database.yml with your local PostgreSQL credentials if they differ from the default).
```

**4. Start Application**
```bash
bin/dev
```
