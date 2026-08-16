--TEAM & VENUE ANALYSIS--
USE IPL_PROJECT;

--1.Highest team totals--
select  top 10 match_id,batting_team,inning,sum(total_runs) as innings_total
from deliveries
group by match_id,batting_team,inning
order by innings_total desc;

--2.Each team highest score in an innings--
select batting_team,max(innings_total) as team_highest_total
from(select  match_id,batting_team,inning,sum(total_runs) as innings_total
from deliveries
group by match_id,batting_team,inning
) as teams_total
group by batting_team
order by team_highest_total desc;

--3.Average first innings score by venue--
with venue_scores as (
select m.venue,m.id,sum(d.total_runs) as total_runs
from matches m
inner join deliveries d
on m.id = d.match_id
where d.inning = 1
group by m.venue,m.id
)

select venue,avg(total_runs) as avg_total
from venue_scores
group by venue
order by avg_total desc;

--4.Average first innings score by venue for each season-- 
with venue_scores as (
select m.season,m.venue,m.id,sum(d.total_runs) as total_runs
from matches m
inner join deliveries d
on m.id = d.match_id
where d.inning = 1
group by m.season,m.venue,m.id
)

select season,venue,avg(total_runs) as avg_total
from venue_scores
group by season,venue
order by season asc,avg_total desc;

--5.Most frequently used venues--
select venue,count(id) as matches_hosted
from matches
group by venue
order by matches_hosted desc;

--6.Most Successful Team at Each Venue--
with each_team_wins as (select venue,winner as team,count(winner) as total_wins
from matches
group by venue,winner
 ),

team_ranks as (
select venue,team,total_wins,
rank() over(partition by venue
order by total_wins desc
)as ranks from each_team_wins 
)

select venue,team,total_wins
from team_ranks
where ranks = 1
order by venue;

