--Advanced Business Analysis--
USE IPL_PROJECT;

--1.Matches played per season--
select season,count(id) as matches_per_season
from matches
group by season
order by season;

--2. Incompleted matches by a season--
select season,id,count(id) as no_result_matches
from matches
where winner ='NA'
group by season,id
order by no_result_matches desc;

--3.Most successful teams--
select winner as team,count(winner) as wins
from matches
group by winner 
order by wins desc;

--4.win percentage over batting-- 
select season,count(*) as total_matches,
concat(cast(
sum(
case
when (toss_decision='bat' and toss_winner=winner) or
(toss_decision = 'field'
and 
case
when toss_winner=team1 then team2
else team1
end=winner) 
then 1 
else 0
end 
)*100.0/count(*)
as decimal(10,2)),'%')as first_bat_win_percentage,
concat(
cast(
sum(
case
when (toss_decision='field' and toss_winner=winner)or
(toss_decision='bat' and case when toss_winner=team1 then team2
else team1 end=winner)
then 1 else 0
end)*100.0/count(*)as decimal(10,2)),'%')as second_bat_win_percentage
from matches
where winner not like 'NA'
group by season
order by 1;


--5.Season-wise top scorer--
with season_runs as (select m.season,d.batter,sum(d.batsman_runs) as total_runs
from matches m
inner join  deliveries d on m.id=d.match_id
group by season,batter),

batter_ranks as (
select season,batter,total_runs,
rank()over(partition by season 
order by total_runs desc) as ranks
from season_runs)

select season,batter,total_runs
from batter_ranks
where ranks = 1
order by season;

--6.Season-wise Top Wicket Taker--
with bowler_wickets as(select m.season,d.bowler,count(d.dismissal_kind) as total_wickets
from matches m
join deliveries d
on m.id=d.match_id
where d.dismissal_kind in ('caught and bowled','bowled','stumped','hit wicket','caught','lbw')
group by m.season,d.bowler),

top_bowlers as (select season,bowler,total_wickets,
rank()over(partition by season
order by total_wickets desc) as bowler_rank
from bowler_wickets)

select season,bowler,total_wickets
from top_bowlers
where bowler_rank = 1
order by season;

--7.Winning percentage by team--
--Approach 1 using derived table--
select team,count(team) as total_matches,sum(case when team=winner then 1 else 0 end) as wins,
concat(cast(sum(case when team=winner then 1 else 0 end)*100.0/count(team) as decimal(10,2)),'%') as win_percentage
from(select team1 as team,winner
from matches
union all
select team2 as team,winner 
from matches )as teams
group by team
order by win_percentage desc;

--Approach 2 using CTE--
with total_matches as(select team,count(*) as matches_played from
(select team1 as team 
from matches
union all
select team2 as team
from matches)as teams
group by team)

select t.team,t.matches_played,count(m.winner)as wins,
concat(cast(count(m.winner)*100.0/t.matches_played as decimal(10,2)),'%') as win_percentage
from total_matches t
left join matches m
on t.team=m.winner
group by t.team,t.matches_played
order by win_percentage desc;

--8.Teams which are consistently performing well--
with team_stats as
(
select team,count(distinct season) as seasons_played,
count(team) as total_matches,sum(case when team=winner then 1 else 0 end) as total_wins,
concat(cast(sum(case when team=winner then 1 else 0 end)*100.0/count(team) as decimal(10,2)),'%') as win_percentage
from(select team1 as team,season,winner
from matches
union all
select team2 as team,season,winner 
from matches )as teams
group by team)

select team,seasons_played,total_matches,total_wins,win_percentage,avg_wins_per_season,
(case when avg_wins_per_season >= 7.0 then 'High'
when avg_wins_per_season >=5.0 then 'Medium'
else 'Low'
end )as Consistancy
from
(select team,seasons_played,total_matches,total_wins,win_percentage,
cast(total_wins*1.0/seasons_played as decimal(10,1)) as avg_wins_per_season
from team_stats)as avg_wins
order by avg_wins_per_season desc









