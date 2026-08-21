-- 맛집 목록을 기기 간에 동기화하기 위한 테이블.
-- 목록 전체를 JSON 한 덩어리로 넣고 뺀다. 행은 id='main' 하나만 쓴다.

create table if not exists date_app_state (
  id         text primary key,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

alter table date_app_state enable row level security;

-- RLS 를 켜고 정책을 하나도 만들지 않으면 읽기까지 전부 막힌다.
-- 아래 두 정책을 넣어야 앱이 동작한다.

-- 상대방(초대받은 사람)도 목록을 읽어야 한다.
drop policy if exists "anon read" on date_app_state;
create policy "anon read" on date_app_state
  for select using (true);

-- 로그인을 두지 않기로 했으므로 쓰기도 열어 둔다.
-- 주소와 공개 키를 아는 사람은 목록을 고칠 수 있다는 뜻이다.
-- 나중에 조이려면 이 정책을 지우고 Supabase Auth 로그인을 붙이면 된다.
drop policy if exists "anon write" on date_app_state;
create policy "anon write" on date_app_state
  for all using (true) with check (true);

-- 첫 행을 만들어 둔다 (앱이 알아서 만들지만 미리 있어도 무방)
insert into date_app_state (id, data)
values ('main', '{"places": [], "course": []}'::jsonb)
on conflict (id) do nothing;

-- ---------------------------------------------------------------
-- 확인용 (읽기만 함, 아무것도 바꾸지 않음)
-- 같은 프로젝트의 다른 테이블들이 RLS 로 보호되고 있는지 본다.
-- 공개 키는 프로젝트 전체가 공유하므로, 이 앱을 공개 저장소에 올리기 전에
-- 한 번 확인해 두는 편이 좋다.
-- ---------------------------------------------------------------
-- select relname as table_name,
--        case when relrowsecurity then 'RLS 켜짐' else 'RLS 꺼짐 - 확인 필요' end as rls
-- from pg_class
-- where relnamespace = 'public'::regnamespace and relkind = 'r'
-- order by relrowsecurity, relname;
