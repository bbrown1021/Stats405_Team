 -- Writing a SQL script to return some queries that may be handy as we investigate our data
 
 
 select *
 from music
 limit 100
 
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
 
 
 -- what's the most common time signature?
 
 select time_signature
		, count(*) count_tracks
FROM music
group by time_signature
order by count_tracks desc
LIMIT 100
 
 -- some pretty weird stuff  going on in the time_signature field. Most common is 4/4 as expected.
 

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
	AND decade like '%s%' -- this is to remove strange values from decade field
order by decade, rn


-- seems like there's some bad data in the decade field as well.


;
 
 
 
 
 
 
 