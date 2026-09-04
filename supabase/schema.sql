-- Casa Clara: esquema para la conexión Supabase.
create extension if not exists "uuid-ossp";

create table if not exists public.households (
  id uuid primary key default uuid_generate_v4(),
  name text not null default 'Casa Clara',
  created_at timestamptz not null default now()
);
create table if not exists public.household_members (
  household_id uuid references public.households(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  display_name text not null,
  role text not null default 'member' check (role in ('owner','member')),
  created_at timestamptz not null default now(),
  primary key (household_id, user_id)
);
create table if not exists public.accounts (
  id uuid primary key default uuid_generate_v4(),
  household_id uuid not null references public.households(id) on delete cascade,
  owner_id uuid references auth.users(id) on delete set null,
  name text not null,
  kind text not null default 'personal' check (kind in ('personal','shared')),
  opening_balance numeric(12,2) not null default 0,
  created_at timestamptz not null default now()
);
create table if not exists public.transactions (
  id uuid primary key default uuid_generate_v4(),
  account_id uuid not null references public.accounts(id) on delete cascade,
  created_by uuid not null references auth.users(id) on delete restrict,
  description text not null,
  category text not null,
  amount numeric(12,2) not null check (amount > 0),
  type text not null check (type in ('income','expense')),
  occurred_on date not null default current_date,
  created_at timestamptz not null default now()
);
create table if not exists public.recurring_payments (
  id uuid primary key default uuid_generate_v4(),
  account_id uuid not null references public.accounts(id) on delete cascade,
  created_by uuid not null references auth.users(id) on delete restrict,
  name text not null,
  amount numeric(12,2) not null check (amount > 0),
  due_day int not null check (due_day between 1 and 31),
  status text not null default 'pending' check (status in ('pending','paid')),
  created_at timestamptz not null default now()
);

create or replace function public.is_household_member(target_household uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.household_members where household_id = target_household and user_id = auth.uid());
$$;
create or replace function public.can_access_account(target_account uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.accounts a where a.id = target_account and public.is_household_member(a.household_id));
$$;
create or replace function public.can_write_account(target_account uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.accounts a
    where a.id = target_account
      and public.is_household_member(a.household_id)
      and (a.kind = 'shared' or a.owner_id = auth.uid())
  );
$$;

alter table public.households enable row level security;
alter table public.household_members enable row level security;
alter table public.accounts enable row level security;
alter table public.transactions enable row level security;
alter table public.recurring_payments enable row level security;

drop policy if exists "members can view household" on public.households;
create policy "members can view household" on public.households for select using (public.is_household_member(id));
drop policy if exists "members can view membership" on public.household_members;
create policy "members can view membership" on public.household_members for select using (user_id = auth.uid() or public.is_household_member(household_id));
drop policy if exists "members can view accounts" on public.accounts;
create policy "members can view accounts" on public.accounts for select using (public.is_household_member(household_id));
drop policy if exists "owners can manage accounts" on public.accounts;
create policy "owners can manage accounts" on public.accounts for all using (public.is_household_member(household_id)) with check (public.is_household_member(household_id));
drop policy if exists "members can view transactions" on public.transactions;
create policy "members can view transactions" on public.transactions for select using (public.can_access_account(account_id));
drop policy if exists "members can add transactions" on public.transactions;
create policy "members can add transactions" on public.transactions for insert with check (created_by = auth.uid() and public.can_write_account(account_id));
drop policy if exists "creator can update transaction" on public.transactions;
create policy "creator can update transaction" on public.transactions for update using (created_by = auth.uid()) with check (created_by = auth.uid());
drop policy if exists "members can view payments" on public.recurring_payments;
create policy "members can view payments" on public.recurring_payments for select using (public.can_access_account(account_id));
drop policy if exists "members can add payments" on public.recurring_payments;
create policy "members can add payments" on public.recurring_payments for insert with check (created_by = auth.uid() and public.can_write_account(account_id));
drop policy if exists "creator can update payments" on public.recurring_payments;
create policy "creator can update payments" on public.recurring_payments for update using (created_by = auth.uid()) with check (created_by = auth.uid());
