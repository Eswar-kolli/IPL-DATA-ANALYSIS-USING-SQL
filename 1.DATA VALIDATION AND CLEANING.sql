--data validation and cleaning queries--

USE IPL_PROJECT;

--1.RECORD COUNT VALIDATION(COUNT THE TOTAL RECORDS OF DATA)--
SELECT 'deliveries' AS TABLE_NAME,COUNT(*) AS total_records
FROM deliveries;

SELECT 'matches' AS table_name,COUNT(*) AS total_records
FROM matches;

--2.Duplicate match detection(Identify duplicate records values in the matches table)--
SELECT id,COUNT(*) AS duplicate_count
FROM matches 
GROUP BY id
HAVING COUNT(*)>1;

SELECT match_id,COUNT(*) AS duplicate_count
FROM deliveries
GROUP BY match_id
HAVING COUNT(*)>1;

--3.Missing values report
SELECT 'id', count(*) as null_count
from matches
where id is null
union all
select 'season',count(*) as null_count
from matches
where season is null
union all
select 'city',count(*) as null_count
from matches
where city is null
union all
select 'date',count(*) as null_count
from matches
where date is null
union all
select 'match_type',count(*) as null_count
from matches
where match_type is null
union all
select 'winner',count(*) as null_count
from matches
where winner is null
union all
select 'player_of_match',count(*) as null_count
from matches
where player_of_match is null
union all
select 'venue',count(*) as null_count
from matches
where venue is null

--4.Season year standardization--
select distinct season from matches
order by season;

UPDATE matches
SET season =CASE WHEN season = '2007/08' THEN '2008'
WHEN season = '2009/10' THEN '2010'
WHEN season = '2020/21' THEN '2020'
ELSE season
END
WHERE season IN ('2007/08', '2009/10', '2020/21');

--5.Team name standardization--
--Team name standardization for deliveries table--
select batting_team from deliveries
union
select bowling_team from deliveries;

UPDATE deliveries
SET batting_team =CASE 
WHEN batting_team = 'Kings XI Punjab' THEN 'Punjab Kings'
WHEN batting_team = 'Delhi Daredevils' THEN 'Delhi Capitals'
WHEN batting_team = 'Royal Challengers Bangalore' THEN 'Royal Challengers Bengaluru'
WHEN batting_team = 'Rising Pune Supergiant' THEN 'Rising Pune Supergiants'
ELSE batting_team
END,
bowling_team =CASE
WHEN bowling_team = 'Kings XI Punjab' THEN 'Punjab Kings'
WHEN bowling_team = 'Delhi Daredevils' THEN 'Delhi Capitals'
WHEN bowling_team = 'Royal Challengers Bangalore' THEN 'Royal Challengers Bengaluru'
WHEN bowling_team = 'Rising Pune Supergiant' THEN 'Rising Pune Supergiants'
ELSE bowling_team
END
WHERE batting_team IN ('Kings XI Punjab','Delhi Daredevils',
'Royal Challengers Bangalore','Rising Pune Supergiant')
OR bowling_team IN ('Kings XI Punjab','Delhi Daredevils',
'Royal Challengers Bangalore',
'Rising Pune Supergiant');

--Team name standardization for matches table--
select team1 as team
from matches
union
select  team2
from matches
union
select  toss_winner
from matches
union
select winner 
from matches;

update matches
set team1= 'Delhi Capitals'
where team1='Delhi Daredevils'
update matches
set team2= 'Delhi Capitals'
where team2='Delhi Daredevils'
update matches
set toss_winner= 'Delhi Capitals'
where toss_winner='Delhi Daredevils'
update matches
set winner= 'Delhi Capitals'
where winner='Delhi Daredevils';

update matches
set team1= 'Punjab Kings'
where team1='Kings XI Punjab'
update matches
set team2= 'Punjab Kings'
where team2='Kings XI Punjab'
update matches
set toss_winner= 'Punjab Kings'
where toss_winner='Kings XI Punjab'
update matches
set winner= 'Punjab Kings'
where winner='Kings XI Punjab';

update matches
set team1= 'Royal Challengers Bengaluru'
where team1='Royal Challengers Bangalore'
update matches
set team2= 'Royal Challengers Bengaluru'
where team2='Royal Challengers Bangalore'
update matches
set toss_winner= 'Royal Challengers Bengaluru'
where toss_winner='Royal Challengers Bangalore'
update matches
set winner= 'Royal Challengers Bengaluru'
where winner='Royal Challengers Bangalore';

update matches
set team1= 'Rising Pune Supergiants'
where team1='Rising Pune Supergiant'
update matches
set team2= 'Rising Pune Supergiants'
where team2='Rising Pune Supergiant'
update matches
set toss_winner= 'Rising Pune Supergiants'
where toss_winner='Rising Pune Supergiant'
update matches
set winner= 'Rising Pune Supergiants'
where winner='Rising Pune Supergiant';

--6.Venue Name Standardization--
select distinct venue from matches;

update matches
set venue = 'Arun Jaitley Stadium, Delhi'
where venue ='Arun Jaitley Stadium';

update matches
set venue = 'Wankhede Stadium, Mumbai'
where venue ='Wankhede Stadium';

update matches
set venue = 'Rajiv Gandhi International Stadium, Uppal, Hyderabad'
where venue ='Rajiv Gandhi International Stadium' or venue='Rajiv Gandhi International Stadium, Uppal'; 

update matches
set venue = 'Brabourne Stadium, Mumbai'
where venue ='Brabourne Stadium';

update matches
set venue = 'Dr DY Patil Sports Academy, Mumbai'
where venue ='Dr DY Patil Sports Academy';

update matches
set venue = 'Dr. Y.S. Rajasekhara Reddy ACA-VDCA Cricket Stadium, Visakhapatnam'
where venue ='Dr. Y.S. Rajasekhara Reddy ACA-VDCA Cricket Stadium';

update matches
set venue = 'Eden Gardens, Kolkata'
where venue ='Eden Gardens';

update matches
set venue = 'Himachal Pradesh Cricket Association Stadium, Dharamsala'
where venue ='Himachal Pradesh Cricket Association Stadium';

update matches
set venue = 'M Chinnaswamy Stadium, Bengaluru'
where venue IN ('M Chinnaswamy Stadium','M.Chinnaswamy Stadium');

update matches
set venue = 'MA Chidambaram Stadium, Chepauk, Chennai'
where venue IN ('MA Chidambaram Stadium','MA Chidambaram Stadium, Chepauk');

update matches
set venue = 'Maharashtra Cricket Association Stadium, Pune'
where venue ='Maharashtra Cricket Association Stadium';

update matches
set venue = 'Punjab Cricket Association IS Bindra Stadium, Mohali, Chandigarh'
where venue IN ('Punjab Cricket Association IS Bindra Stadium','Punjab Cricket Association IS Bindra Stadium, Mohali',
'Punjab Cricket Association Stadium, Mohali');

update matches
set venue = 'Sawai Mansingh Stadium, Jaipur'
where venue ='Sawai Mansingh Stadium';

update matches
set venue = 'Sawai Mansingh Stadium, Jaipur'
where venue ='Sawai Mansingh Stadium';
