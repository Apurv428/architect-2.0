-- The platform's own agent export is the JSON blueprint, and it is the default framework.
-- Rows holding an id the app no longer lists are moved onto it. Safe to re-run.

alter table public.agents alter column framework set default 'blueprint';

-- The touch triggers are paused so this rename doesn't reorder everyone's recent projects.
alter table public.agents disable trigger agents_touch;
alter table public.projects disable trigger projects_touch;

update public.agents
set framework = 'blueprint'
where framework not in ('blueprint', 'langgraph', 'crewai', 'openai-agents', 'claude-agent-sdk', 'google-adk');

update public.projects
set framework = 'blueprint'
where framework is not null
  and framework not in ('blueprint', 'langgraph', 'crewai', 'openai-agents', 'claude-agent-sdk', 'google-adk');

alter table public.agents enable trigger agents_touch;
alter table public.projects enable trigger projects_touch;
