-- Supabase setup for Imam Fatkhuroji Digital CV
-- 1) Create an Auth user with email: imamaxzy@gmail.com
-- 2) Run this entire SQL in Supabase SQL Editor.
-- 3) The website uses only the publishable/anon key in the browser.

create table if not exists public.profile_settings (
  id bigint primary key check (id = 1),
  image_url text,
  updated_at timestamptz not null default now()
);

alter table public.profile_settings enable row level security;

drop policy if exists "Public can read profile settings" on public.profile_settings;
drop policy if exists "Owner can insert profile settings" on public.profile_settings;
drop policy if exists "Owner can update profile settings" on public.profile_settings;

create policy "Public can read profile settings"
on public.profile_settings
for select
using (true);

create policy "Owner can insert profile settings"
on public.profile_settings
for insert
to authenticated
with check ((auth.jwt() ->> 'email') = 'imamaxzy@gmail.com');

create policy "Owner can update profile settings"
on public.profile_settings
for update
 to authenticated
using ((auth.jwt() ->> 'email') = 'imamaxzy@gmail.com')
with check ((auth.jwt() ->> 'email') = 'imamaxzy@gmail.com');

grant select on public.profile_settings to anon, authenticated;
grant insert, update on public.profile_settings to authenticated;

insert into public.profile_settings (id, image_url)
values (1, null)
on conflict (id) do nothing;

-- Public bucket: visitors must be able to see the profile image.
insert into storage.buckets (id, name, public)
values ('profile', 'profile', true)
on conflict (id) do update set public = true;

-- Storage policies: only the owner email can upload/replace/delete the profile image.
drop policy if exists "Public can view profile image" on storage.objects;
drop policy if exists "Owner can upload profile image" on storage.objects;
drop policy if exists "Owner can update profile image" on storage.objects;
drop policy if exists "Owner can delete profile image" on storage.objects;

create policy "Public can view profile image"
on storage.objects
for select
using (bucket_id = 'profile');

create policy "Owner can upload profile image"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'profile'
  and (auth.jwt() ->> 'email') = 'imamaxzy@gmail.com'
);

create policy "Owner can update profile image"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'profile'
  and (auth.jwt() ->> 'email') = 'imamaxzy@gmail.com'
)
with check (
  bucket_id = 'profile'
  and (auth.jwt() ->> 'email') = 'imamaxzy@gmail.com'
);

create policy "Owner can delete profile image"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'profile'
  and (auth.jwt() ->> 'email') = 'imamaxzy@gmail.com'
);
