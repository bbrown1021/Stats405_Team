 -- Writing a SQL script to return some queries that may be handy as we investigate our data
 
 
 select *
 from music
 limit 100
 
 ;
 
 select *
 from dataDictionary
 
 ;
 
 
 -- what are the top 10 bands with the fastest average tempo of their catalogue
 -- limit to having at least 10 songs
 
 select artist
		, avg(tempo) avg_song_tempo
        , COUNT(DISTINCT track) count_songs
from music
group by artist
HAVING  count_songs >= 10
order by avg_song_tempo desc
limit 10


-- Crass is number one, Crass rules

;
 
 
 -- descriptive statistics by time signature
 
 select time_signature
		, count(*) count_tracks
        , avg(danceability) avg_danceability
        , avg(acousticness) avg_acousticness
        , avg(energy) avg_energy
        , SUM(hit) count_hits
        , SUM(hit)/count(*) as percentage_hit
FROM music
group by time_signature
order by count_tracks desc

 


 ;
 
 -- descriptive statistics by key
 
 select song_key
		, count(*) count_tracks
        , avg(danceability) avg_danceability
        , avg(acousticness) avg_acousticness
        , avg(energy) avg_energy
        , SUM(hit) count_hits
        , SUM(hit)/count(*) as percentage_hit
FROM music
group by song_key
order by count_tracks desc

 


 ;
 
 -- pretty simple check to see which artist has the most songs per decade
 
 SELECT *
 FROM (
	 select artist
			, decade
			, COUNT(DISTINCT track) count_songs
			, ROW_NUMBER() OVER(PARTITION BY decade ORDER BY COUNT(DISTINCT track) desc) as rn
	from music
	group by artist, decade
	order by count_songs desc) x
WHERE rn <= 10
order by decade, rn


;
 
 
 
 
 
 
 