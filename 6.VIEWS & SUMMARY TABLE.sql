--VIEWS & Summary Table--

USE IPL_PROJECT;

--1.view matches count in venue
create view vw_venue_matches as
select venue,count(id) as matches_hosted
from matches
group by venue;

--2.view Team performance--
create view vw_team_performance as
with team_stats as 
(select team,count(*) as total_matches,sum(case when team=winner then 1 else 0 end)as wins from
(select team1 as team,winner
from matches
union all 
select team2,winner
from matches
)as teams
group by team)

select team,total_matches,wins,
concat(cast(wins*100.0/total_matches as decimal(10,2)),'%') as win_percentage
from team_stats
group by team,total_matches,wins;

--3.view Batsman performance
create view vw_batsman_performance as
select m.season,d.batter,sum(d.batsman_runs) as total_runs,count(distinct d.match_id) as matches_played
from matches m
inner join deliveries d
on m.id=d.match_id
group by m.season,d.batter;

--4.view Bowler performance--
create view vw_bowler_performance as 
select m.season,d.bowler,count(d.dismissal_kind)as total_wickets
from matches m
Inner join deliveries d 
on m.id = d.match_id
where dismissal_kind in ('caught and bowled','bowled','stumped','hit wicket','caught','lbw')
group by m.season,d.bowler;

--5.view venue performance--
create view vw_venue_performance as
with innings_total as
(select m.venue,d.match_id,d.inning,sum(d.total_runs) as inning_total
from matches m
inner join deliveries d
on m.id=d.match_id
group by m.venue,d.match_id,d.inning)

select venue,count(distinct match_id) as matches_played,
max(inning_total)as highest_inning_total,
ceiling(avg(inning_total*1.0)) as avg_inning_score
from innings_total
group by venue;


--6.Creating a Summary Table--
create table season_summary(
season int,
matches_played tinyint,
completed_matches tinyint,
no_result_matches tinyint,
teams_participated tinyint,
teams_with_wins tinyint,
unique_cities tinyint,
unique_venues tinyint,
total_runs int,
avg_match_runs decimal(10,2),
highest_innings_score int,
toss_winner_match_winner tinyint,
toss_win_match_win_percent decimal(10,2))

--Insert values to summary table--
with match_stats as(
select season,count(*) as matches_played,
sum(case when winner <>'NA' and winner is not null then 1 else 0 end) as completed_matches,
sum(case when winner ='NA' or winner is null then 1 else 0 end) as no_result_matches,
count(distinct city) as unique_cities,
count(distinct venue) as unique_venues
from matches
group by season),

 teams as 
(select season,team1 as team
from matches
union
select season,team2 as team 
from matches),

team_stats as
(select season,count(distinct team)as teams_participated
from teams
group by season),

match_wins as
(select season,count(distinct case
when winner is not null and winner <>'NA' then winner end )as teams_with_wins,
sum(case when toss_winner=winner and 
winner is not null 
and winner <> 'NA' then 1 else 0 end)as toss_winner_match_winner,
cast(sum(case when toss_winner=winner and winner is not null and winner <> 'NA' then 1 else 0 end)*100.0/
nullif(count(case when winner is not null and winner <> 'NA' then 1 end),0)as decimal(10,2))
as toss_win_match_win_percentage
from matches 
group by season),

run_stats as
(select m.season,sum(d.total_runs) as total_runs,
cast(sum(d.total_runs)*1.0/count(distinct d.match_id)as decimal(10,2)) as avg_match_runs
from matches m
inner join deliveries d
on m.id=d.match_id
group by m.season),

innings_scores as
(select m.season,d.match_id,d.inning,
sum(d.total_runs) as innings_total
from matches m
inner join deliveries d
on m.id=d.match_id
group by m.season,d.match_id,d.inning),

highest_score as 
(select season,max(innings_total) as highest_innings_score
from innings_scores
group by season)

insert into season_summary(season,
matches_played,
completed_matches,
no_result_matches,
teams_participated,
teams_with_wins,
unique_cities,
unique_venues,
total_runs,
avg_match_runs,
highest_innings_score,
toss_winner_match_winner,
toss_win_match_win_percent)

select ms.season,ms.matches_played,ms.completed_matches,ms.no_result_matches,
ts.teams_participated,
mw.teams_with_wins,
ms.unique_cities,
ms.unique_venues,
rs.total_runs,
rs.avg_match_runs,
hs.highest_innings_score,
mw.toss_winner_match_winner,
mw.toss_win_match_win_percentage

from match_stats ms
left join team_stats ts
on ms.season=ts.season
left join match_wins mw
on ms.season=mw.season
left join run_stats rs
on ms.season=rs.season
left join highest_score hs
on ms.season= hs.season;










