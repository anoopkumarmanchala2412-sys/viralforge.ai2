# ViralForge AI 🔥

> Generate viral YouTube Shorts, Instagram Reels, and TikTok content in seconds with AI.

## Tech Stack
- **Next.js 14** (App Router)
- **TypeScript**
- **Tailwind CSS**
- **Supabase** (Auth + Database)
- **Groq API** (LLaMA 3.3 70B — fastest AI inference)
- **react-hot-toast**, **next-themes**, **lucide-react**

---

## 🚀 Quick Setup (5 minutes)

### Step 1 — Clone & Install

```bash
git clone <your-repo>
cd viralforge
npm install
```

### Step 2 — Get Your API Keys

#### Supabase
1. Go to [app.supabase.com](https://app.supabase.com)
2. Create a new project
3. Go to **Settings → API**
4. Copy:
   - `Project URL` → `NEXT_PUBLIC_SUPABASE_URL`
   - `anon public` key → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `service_role` key → `SUPABASE_SERVICE_ROLE_KEY`

#### Groq API Key
1. Go to [console.groq.com/keys](https://console.groq.com/keys)
2. Create a new API key
3. Copy it → `GROQ_API_KEY`

### Step 3 — Configure Environment

```bash
cp .env.local.example .env.local
```

Edit `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://yourproject.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# ⬇️ ADD YOUR GROQ API KEY HERE ⬇️
GROQ_API_KEY=gsk_...

NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Step 4 — Set Up Database

1. Go to your Supabase project
2. Click **SQL Editor** → **New Query**
3. Paste the contents of `supabase-setup.sql`
4. Click **Run**

This creates:
- `generations` table (stores all AI outputs)
- `profiles` table (user metadata)
- Row Level Security policies (users only see their own data)
- Indexes for performance
- Auto-profile trigger on signup

### Step 5 — Configure Supabase Auth

1. Go to **Authentication → URL Configuration**
2. Set **Site URL**: `http://localhost:3000`
3. Add **Redirect URLs**: `http://localhost:3000/auth/callback`

For production, replace `localhost:3000` with your domain.

### Step 6 — Run Locally

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) 🎉

---

## 📦 Deploy to Vercel

```bash
npm i -g vercel
vercel
```

Add all environment variables in Vercel Dashboard → Project → Settings → Environment Variables.

Update Supabase Auth redirect URLs with your production domain.

---

## 🏗️ Project Structure

```
src/
├── app/
│   ├── page.tsx              # Landing page
│   ├── layout.tsx            # Root layout
│   ├── globals.css           # Global styles
│   ├── api/
│   │   └── generate/route.ts # AI generation API
│   ├── auth/
│   │   ├── login/page.tsx
│   │   ├── signup/page.tsx
│   │   ├── forgot-password/page.tsx
│   │   └── callback/route.ts
│   ├── dashboard/page.tsx    # Main generate UI
│   ├── history/page.tsx      # Generation history
│   └── settings/page.tsx     # User settings
├── components/
│   ├── layout/
│   │   ├── navbar.tsx
│   │   ├── sidebar.tsx
│   │   ├── mobile-nav.tsx
│   │   └── footer.tsx
│   ├── dashboard/
│   │   ├── results-display.tsx
│   │   ├── history-client.tsx
│   │   └── settings-client.tsx
│   └── ui/
│       └── theme-provider.tsx
├── lib/
│   ├── groq.ts               # AI generation logic
│   └── supabase/
│       ├── client.ts         # Browser Supabase client
│       ├── server.ts         # Server Supabase client
│       └── middleware.ts     # Auth middleware
└── types/index.ts            # TypeScript types
```

---

## 🔑 Where to Add GROQ_API_KEY

**Development**: `.env.local` file (never commit this)

```env
GROQ_API_KEY=gsk_your_key_here
```

**Production (Vercel)**:
1. Vercel Dashboard → Your Project → Settings → Environment Variables
2. Add `GROQ_API_KEY` with your key value

The key is used server-side only in `src/lib/groq.ts` and `src/app/api/generate/route.ts`. It's never exposed to the browser.

---

## 🤖 AI Model

ViralForge uses **LLaMA 3.3 70B** via Groq:
- Model: `llama-3.3-70b-versatile`
- Response format: JSON (structured outputs)
- Speed: ~2-3 seconds per generation
- Free tier: 14,400 requests/day

---

## 📊 Database Schema

```sql
generations (
  id          UUID PRIMARY KEY
  user_id     UUID → auth.users
  topic       TEXT
  platform    TEXT  -- 'YouTube Shorts' | 'Instagram Reels' | 'TikTok'
  style       TEXT  -- 'Motivation' | 'Business' | etc.
  length      TEXT  -- '30 Seconds' | '60 Seconds' | '90 Seconds'
  content     JSONB -- All 10 generated content pieces
  created_at  TIMESTAMPTZ
)
```

---

## ✅ Features Checklist

- [x] Landing page (Hero, Features, Pricing, Testimonials, FAQ, CTA)
- [x] Authentication (Signup, Login, Logout, Forgot Password)
- [x] Dashboard with content generation form
- [x] 10 AI-generated content assets
- [x] Copy button for every section
- [x] Download as TXT
- [x] Auto-save to Supabase
- [x] History page with search & delete
- [x] Settings (Profile, Theme, API info)
- [x] Dark/Light mode
- [x] Mobile responsive
- [x] Loading states & animations
- [x] Error handling with toasts
- [x] TypeScript throughout
- [x] Row Level Security

---

Built with ❤️ using ViralForge AI
