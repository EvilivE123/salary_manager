# Salary Manager

> A high-performance Ruby on Rails application designed to streamline employee data management, track compensation KPIs, and securely administer role-based payroll operations through a dynamic dashboard.

## 🚀 Tech Stack

* **Framework:** Rails 8.1.3
* **Database:** PostgreSQL 16.13
* **Deployment:** Containerized via Docker (Back4App)

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
bundle install
rails db:setup
bin/dev
