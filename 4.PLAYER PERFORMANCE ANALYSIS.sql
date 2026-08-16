--PLAYER PERFORMANCE ANALYSIS--
USE IPL_PROJECT;

--1.Top 10 run scorers--
--Approach 1 using TOP--
select top 10 batter , sum(batsman_runs) as total_runs --select top 10 batter,sum....--
from deliveries
group by batter
order by total_runs desc;

--Approach 2 using FETCH & OFFSET--
select batter , sum(batsman_runs) as total_runs --select top 10 batter,sum....--
from deliveries
group by batter
order by total_runs desc
offset 0 rows
fetch next 10 rows only;

--2.Top 10 wicket takers--
select top 10 bowler, count(dismissal_kind) as total_wickets
from deliveries
where dismissal_kind in ('caught and bowled', 'bowled','stumped','hit wicket','caught','lbw') 
and bowler is not null
group by bowler
order by total_wickets desc;

--3.Highest individual score in a match--
select  top 1 batter,match_id, --for each match remove top 1--
sum(batsman_runs) as highest_batter_score
from deliveries
group by batter,match_id
order by highest_batter_score desc;

--4.Most Player of the Match awards--
select top 1 player_of_match as player,count(player_of_match)as most_POM_awards
from matches
where player_of_match is not null
group by player_of_match
order by most_POM_awards desc;