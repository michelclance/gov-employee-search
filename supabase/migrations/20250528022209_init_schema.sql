-- === states ===============================================================
create table if not exists states (
  state_code char(2) primary key,
  state_name text not null
);

insert into states (state_code, state_name) values
  ('AL','Alabama'), ('AK','Alaska'), ('AZ','Arizona'), ('AR','Arkansas'),
  ('CA','California'), ('CO','Colorado'), ('CT','Connecticut'), ('DE','Delaware'),
  ('FL','Florida'), ('GA','Georgia'), ('HI','Hawaii'), ('ID','Idaho'),
  ('IL','Illinois'), ('IN','Indiana'), ('IA','Iowa'), ('KS','Kansas'),
  ('KY','Kentucky'), ('LA','Louisiana'), ('ME','Maine'), ('MD','Maryland'),
  ('MA','Massachusetts'), ('MI','Michigan'), ('MN','Minnesota'), ('MS','Mississippi'),
  ('MO','Missouri'), ('MT','Montana'), ('NE','Nebraska'), ('NV','Nevada'),
  ('NH','New Hampshire'), ('NJ','New Jersey'), ('NM','New Mexico'), ('NY','New York'),
  ('NC','North Carolina'), ('ND','North Dakota'), ('OH','Ohio'), ('OK','Oklahoma'),
  ('OR','Oregon'), ('PA','Pennsylvania'), ('RI','Rhode Island'), ('SC','South Carolina'),
  ('SD','South Dakota'), ('TN','Tennessee'), ('TX','Texas'), ('UT','Utah'),
  ('VT','Vermont'), ('VA','Virginia'), ('WA','Washington'), ('WV','West Virginia'),
  ('WI','Wisconsin'), ('WY','Wyoming')
on conflict do nothing;

-- === offices =============================================================
create table if not exists offices (
  office_id bigserial primary key,
  state_code char(2) references states(state_code),
  office_name text not null,
  unique (state_code, office_name)
);

-- === employees ===========================================================
create table if not exists employees (
  employee_id bigserial primary key,
  state_code char(2) references states(state_code),
  office_id  bigint references offices(office_id),
  full_name  text not null,
  position_title text,
  hire_date date,
  separation_date date
);

-- === enable pg_trgm for fast LIKE/ILIKE search =========
create extension if not exists pg_trgm;

-- === indexes for faster search =========================
create index if not exists employees_full_name_trgm
  on employees using gin (full_name gin_trgm_ops);
  
-- === indexes for faster search ==========================================
create index if not exists employees_full_name_trgm
  on employees using gin (full_name gin_trgm_ops);

create index if not exists employees_office_idx
  on employees (office_id);

-- === basic RLS: allow public read, block writes ==========================
alter table states    enable row level security;
alter table offices   enable row level security;
alter table employees enable row level security;

create policy "Public read" on states
  for select using (true);
create policy "Public read" on offices
  for select using (true);
create policy "Public read" on employees
  for select using (true);