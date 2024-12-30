# 🎓 Fellowships4You 🌟

```ascii
 _____ _ _           _     _          _  _   __   
|  ___| | | _____  _| |___| |__  _ __(_)| | / /_  
| |_  | | |/ _ \ \/ / / __| '_ \| '_ \| | |/ / _` |
|  _| | | |  __/>  <| \__ \ | | | |_) | |   < (_| |
|_|   |_|_|\___/_/\_\_|___/_| |_| .__/|_|_|\_\__,_|
                                |_|    4You
```

> Your gateway to academic excellence through scholarships and fellowships! 🚀

## 📚 Table of Contents
- [🛠️ Setup](#%EF%B8%8F-setup)
- [🏗️ Project Structure](#%EF%B8%8F-project-structure)
- [🧭 User Journey](#-user-journey)
- [🧪 Development](#-development)
- [👥 Contributing](#-contributing)

## 🛠️ Setup

### Prerequisites 📋
```
✨ Ruby 3.1.2
🛤️ Rails 7.2.2
🐘 PostgreSQL
📦 Node.js & Yarn
```

### Quick Start 🚀

1. **Clone & Install** 📥
```bash
git clone https://github.com/your-repo/fellowships4you.git
cd fellowships4you
bundle install
yarn install
```

2. **Database Setup** 🗄️
```bash
rails db:create
rails db:migrate
rails db:seed  # Optional: Add sample data
```

3. **Environment Variables** 🔐
Create `.env` in root directory:
```env
# 🔑 Google OAuth
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret

# 💳 Stripe
STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key
STRIPE_SECRET_KEY=your-stripe-secret-key
STRIPE_WEBHOOK_SECRET=your-stripe-webhook-secret
```

4. **Launch** 🚀
```bash
rails server
```
Visit: http://localhost:3000 ✨

## 🏗️ Project Structure

```ascii
fellowships4you/
├── 📁 app/               # Core application files
│   ├── 📱 controllers/   # Request handling
│   ├── 🎨 views/        # UI templates
│   └── 🧬 models/       # Data & business logic
├── 📁 config/           # App configuration
├── 📁 db/               # Database files
├── 📁 public/           # Static assets
└── 📁 test/             # Test suite
```

## 🧭 User Journey

### Landing Page (/) 🏠
```ascii
┌────────────────────────────────────────────┐
│     🎓 Fellowships4You                     │
│  [🔑 Sign In with Google]                  │
│  [🔍 Explore Scholarships]                 │
│  [📚 Buy Fellowship Guide ($99)]           │
└────────────────────────────────────────────┘
```

### Scholarships (/scholarships) 📜
```ascii
┌────────────────────────────────────────────┐
│  🔍 Search Scholarships                    │
│  ├── 📋 Filter by Field                   │
│  ├── 🌍 Filter by Location                │
│  └── 💰 Filter by Amount                  │
│                                           │
│  [⭐ Bookmark] [📤 Share] [📝 Apply]      │
└────────────────────────────────────────────┘
```

### User Dashboard (/home) 🎯
```ascii
┌────────────────────────────────────────────┐
│  👋 Welcome back, Scholar!                 │
│  ├── 📌 Bookmarked Scholarships           │
│  ├── 📅 Upcoming Deadlines                │
│  └── 📊 Application Progress              │
└────────────────────────────────────────────┘
```

## 🧪 Development

### Testing 🧪
```bash
rails test                 # Run all tests
rails test:system         # Run system tests
rails test:controllers    # Run controller tests
```

### Code Quality 🎯
```bash
rubocop                   # Ruby linting
yarn lint                 # JavaScript linting
```

### CI/CD Pipeline 🔄
- 🔍 Automated testing on push
- 🎯 Code quality checks
- 🚀 Automated deployment

## 👥 Contributing

1. 🍴 Fork the repository
2. 🌿 Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit changes (`git commit -m 'Add AmazingFeature'`)
4. 🚀 Push to branch (`git push origin feature/AmazingFeature`)
5. 🎯 Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

🌟 **Happy Scholarship Hunting!** 🌟

Made with ❤️ by the Fellowships4You Team

</div>
