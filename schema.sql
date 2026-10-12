-- Roti Pagi Bakery Payroll schema for Supabase PostgreSQL
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role text not null default 'payroll_staff' check (role in ('admin','payroll_staff')),
  created_at timestamptz not null default now()
);
create table if not exists public.employees (
  id uuid primary key default gen_random_uuid(), employee_code text not null unique,
  full_name text not null, position text not null, department text not null,
  employment_type text not null default 'Tetap', join_date date not null default current_date,
  base_salary numeric(14,2) not null default 0 check(base_salary>=0), phone text,
  status text not null default 'Aktif' check(status in ('Aktif','Tidak Aktif')),
  created_at timestamptz not null default now()
);
create table if not exists public.attendance (
  id uuid primary key default gen_random_uuid(), employee_id uuid not null references public.employees(id) on delete restrict,
  attendance_date date not null, attendance_status text not null check(attendance_status in ('Hadir','Izin','Sakit','Alpha','Libur')),
  regular_hours numeric(5,2) not null default 0 check(regular_hours between 0 and 24),
  overtime_hours numeric(5,2) not null default 0 check(overtime_hours between 0 and 24), notes text,
  created_at timestamptz not null default now(), unique(employee_id,attendance_date)
);
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(), product_code text not null unique,
  product_name text not null unique, incentive_rate numeric(12,2) not null default 0 check(incentive_rate>=0),
  status text not null default 'Aktif' check(status in ('Aktif','Tidak Aktif')), created_at timestamptz not null default now()
);
create table if not exists public.production_records (
  id uuid primary key default gen_random_uuid(), employee_id uuid not null references public.employees(id) on delete restrict,
  product_id uuid references public.products(id) on delete set null, production_date date not null,
  product_type text not null, quantity_produced integer not null check(quantity_produced>=0),
  quantity_accepted integer not null check(quantity_accepted>=0 and quantity_accepted<=quantity_produced),
  incentive_rate numeric(12,2) not null default 0 check(incentive_rate>=0), notes text,
  created_at timestamptz not null default now()
);
create table if not exists public.payroll_settings (
  id uuid primary key default gen_random_uuid(), setting_key text not null unique,
  setting_value jsonb not null default '{}'::jsonb, description text,
  updated_at timestamptz not null default now()
);
create table if not exists public.payrolls (
  id uuid primary key default gen_random_uuid(), payroll_number text not null unique,
  employee_id uuid not null references public.employees(id) on delete restrict,
  period_month date not null check(extract(day from period_month)=1),
  base_salary numeric(14,2) not null default 0 check(base_salary>=0), fixed_allowance numeric(14,2) not null default 0 check(fixed_allowance>=0),
  attendance_bonus numeric(14,2) not null default 0 check(attendance_bonus>=0), overtime_pay numeric(14,2) not null default 0 check(overtime_pay>=0),
  production_incentive numeric(14,2) not null default 0 check(production_incentive>=0), absence_deduction numeric(14,2) not null default 0 check(absence_deduction>=0),
  other_deductions numeric(14,2) not null default 0 check(other_deductions>=0), bpjs_deduction numeric(14,2) not null default 0 check(bpjs_deduction>=0), income_tax_deduction numeric(14,2) not null default 0 check(income_tax_deduction>=0),
  gross_pay numeric(14,2) not null default 0, total_deductions numeric(14,2) not null default 0, net_pay numeric(14,2) not null default 0,
  status text not null default 'Draft' check(status in ('Draft','Disetujui','Dibayar')), paid_at timestamptz,
  calculation_snapshot jsonb not null default '{}'::jsonb, created_at timestamptz not null default now(),
  unique(employee_id,period_month)
);
create index if not exists idx_attendance_date on public.attendance(attendance_date);
create index if not exists idx_production_date on public.production_records(production_date);
create index if not exists idx_payroll_period on public.payrolls(period_month);
create index if not exists idx_payroll_employee on public.payrolls(employee_id);

-- RLS: only authenticated users can access payroll data. In production, refine policies by role.
alter table public.profiles enable row level security;
alter table public.employees enable row level security;
alter table public.attendance enable row level security;
alter table public.products enable row level security;
alter table public.production_records enable row level security;
alter table public.payroll_settings enable row level security;
alter table public.payrolls enable row level security;

drop policy if exists "profile read own" on public.profiles;
create policy "profile read own" on public.profiles for select to authenticated using (auth.uid()=id);
drop policy if exists "profile update own" on public.profiles;
create policy "profile update own" on public.profiles for update to authenticated using (auth.uid()=id) with check (auth.uid()=id);

do $$ declare t text; begin
  foreach t in array array['employees','attendance','products','production_records','payroll_settings','payrolls'] loop
    execute format('drop policy if exists %I on public.%I', t||'_authenticated_access', t);
    execute format('create policy %I on public.%I for all to authenticated using (true) with check (true)', t||'_authenticated_access', t);
  end loop;
end $$;

insert into public.products(product_code,product_name,incentive_rate) values
 ('PRD-001','Roti Tawar',150),('PRD-002','Roti Manis',200),('PRD-003','Roti Cokelat',225),
 ('PRD-004','Roti Keju',225),('PRD-005','Donat',175),('PRD-006','Croissant',300),('PRD-007','Roti Sobek',250)
on conflict(product_code) do nothing;
insert into public.payroll_settings(setting_key,setting_value,description) values
 ('company', '{"name":"Roti Pagi Bakery","address":"Alamat perusahaan dapat diatur administrator"}', 'Identitas perusahaan'),
 ('payroll_policy', '{"overtime_rate_per_hour":0,"fixed_allowance":0,"attendance_bonus":0,"absence_deduction_per_day":0,"bpjs_deduction":0,"income_tax_deduction":0,"regular_hours_per_day":8}', 'Parameter awal; sesuaikan kebijakan dan aturan resmi sebelum digunakan')
on conflict(setting_key) do nothing;

-- Tidak ada seed data karyawan/penggajian otomatis agar data contoh tidak masuk ke database produksi.
-- Buat user melalui Supabase Authentication > Users. Setelah login, buat baris profiles dengan id yang sama.
