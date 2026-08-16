--TOSS-IMPACT-ANALYSIS--

USE IPL_PROJECT;
--1.Toss impact analysis--
select count(id) as total_matches,
sum(case when toss_winner = winner then 1 else 0 end)as toss_win_and_match_win,
concat (cast(
sum(case when toss_winner = winner then 1 else 0 end)*100.0/count(id)
as decimal(10,2)),'%')as conversion_percentage
from matches;

--2.toss impact for each season--
select season,count(id) as total_matches,
sum(case when toss_winner = winner then 1 else 0 end)as toss_win_and_match_win,
concat(cast(
sum(case when toss_winner = winner then 1 else 0 end)*100.0/count(id)
as decimal(10,2)),'%')as conversion_percentage
from matches
group by season
order by season;

--3.Toss Decision Preference
select toss_decision,count(toss_decision) as toss_prefernce
from matches
group by toss_decision;

--4.toss preference in each season--
select season,toss_decision,count(toss_decision) as toss_prefernce
from matches
group by season,toss_decision
order by season;

--5.win percentage over toss decision--
select season,toss_decision,count(*) as total_matches,
sum(case
when toss_winner=winner then 1 else 0 end) as toss_winner_and_won,
concat(cast(sum(case
when toss_winner=winner then 1 else 0 end)*100.0/count(*) as decimal(10,2)),'%') as win_percentage
from matches
group by season,toss_decision
order by season;
