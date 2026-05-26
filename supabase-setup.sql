-- ============================================================
-- ViralForge AI — Supabase Database Setup
-- Run this in your Supabase SQL Editor:
-- Dashboard → SQL Editor → New Query → Paste → Run
-- ============================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================================
-- TABLE: generations
-- Stores all AI-generated content for each user
-- ============================================================
create table if not exists public.generations (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  topic       text not null,
  platform    text not null check (platform in ('YouTube Shorts', 'Instagram Reels', 'TikTok')),
  style       text not null check (style in ('Motivation', 'Business', 'Facts', 'History', 'Storytelling', 'Self Improvement')),
  length      text not null check (length in ('30 Seconds', '60 Seconds', '90 Seconds')),
  content     jsonb not null,
  created_at  timestamptz not null default now()
);

-- ============================================================
-- ROW LEVEL SECURITY — Users can only access their own data
-- ============================================================
alter table public.generations enable row level security;

-- Policy: select own rows
create policy "Users can view their own generations"
  on public.generations for select
  using (auth.uid() = user_id);

-- Policy: insert own rows
create policy "Users can insert their own generations"
  on public.generations for insert
  with check (auth.uid() = user_id);

-- Policy: delete own rows
create policy "Users can delete their own generations"
  on public.generations for delete
  using (auth.uid() = user_id);

-- ============================================================
-- INDEX for performance
-- ============================================================
create index if not exists idx_generations_user_id
  on public.generations(user_id);

create index if not exists idx_generations_created_at
  on public.generations(created_at desc);

-- ============================================================
-- OPTIONAL: profiles table for extended user metadata
-- ============================================================
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text,
  avatar_url  text,
  updated_at  timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Users can view their own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id);

create policy "Users can insert their own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ============================================================
-- Done! Your database is ready.
-- ============================================================
