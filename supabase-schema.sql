-- ============================================================
-- مسابقة توقعات كأس العالم 2026 — مخطط قاعدة بيانات Supabase
-- شغّل هذا الملف كاملًا في: Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================

-- 1) توقعات المشاركين
create table if not exists public.predictions (
  id           text primary key,
  name         text not null,
  pred         jsonb not null,
  is_draft     boolean not null default true,
  submitted_at timestamptz,
  updated_at   timestamptz not null default now()
);

-- 2) النتائج الفعلية للبطولة (صف واحد)
create table if not exists public.results (
  id    int primary key default 1,
  data  jsonb not null,
  updated_at timestamptz not null default now(),
  constraint results_single check (id = 1)
);

-- 3) نتائج المباريات (صف واحد يحوي كل المباريات)
create table if not exists public.matches (
  id    int primary key default 1,
  data  jsonb not null,
  updated_at timestamptz not null default now(),
  constraint matches_single check (id = 1)
);

-- ============================================================
-- أمان الصفوف (RLS): الدخول بالاسم فقط، فنسمح بالقراءة/الكتابة
-- العامة عبر مفتاح anon. مناسب لمسابقة ودّية. لا تضع بيانات حساسة.
-- ============================================================
alter table public.predictions enable row level security;
alter table public.results     enable row level security;
alter table public.matches     enable row level security;

drop policy if exists "p_all" on public.predictions;
create policy "p_all" on public.predictions for all using (true) with check (true);

drop policy if exists "r_all" on public.results;
create policy "r_all" on public.results for all using (true) with check (true);

drop policy if exists "m_all" on public.matches;
create policy "m_all" on public.matches for all using (true) with check (true);

-- ============================================================
-- (اختياري) تحديث لحظي realtime:
-- Dashboard → Database → Replication → فعّل public.predictions و public.results و public.matches
-- ============================================================
