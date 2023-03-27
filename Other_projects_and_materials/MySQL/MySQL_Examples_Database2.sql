# The following code depends on a database that is available in a folder named "databases" under the name "database2"

# Select all Bands that have Albums and at least 30 songs
SELECT 
    ANY_VALUE(bands.name) `Band name`, 
    count(songs.id) `Number of songs` 
FROM bands
    INNER JOIN albums ON albums.band_id = bands.id
    INNER JOIN songs ON albums.id=songs.album_id
GROUP BY bands.id
HAVING  `Number of songs` >= 30;

# Select all Bands that have No Albums
SELECT bands.name  
FROM bands 
    LEFT JOIN albums on bands.id = albums.band_id 
WHERE albums.id IS NULL;

# Get the Longest Album
SELECT 
    a.name, 
    release_year, 
    sum(length) AS duration 
FROM albums a, songs s 
WHERE a.id=s.album_id 
GROUP BY a.id 
ORDER BY duration 
DESC LIMIT 1;

# Update the Release Year of the Album with no Release Year
SELECT id 
FROM albums 
WHERE release_year IS NULL;

UPDATE albums 
SET release_year = 1986 
WHERE id = 4;

# Insert a record for one band and two of their Albums
INSERT INTO bands (name) VALUES ('Pat Metheny');

INSERT INTO  albums 
VALUES (19, 'Travels', 1983, (SELECT id FROM bands WHERE name = 'Pat Metheny'));

INSERT INTO  albums 
VALUES (20, 'Letter from Home', 1989, (SELECT id FROM bands WHERE name = 'Pat Metheny'));

# Delete the last added album
DELETE FROM albums 
WHERE band_id=8 
ORDER BY id DESC LIMIT 1;

# Select the maximum, minimum, and average length of Songs for each band
SELECT 
    bands.name,
    MAX(length) `Maximum length`,
    MIN(length) `Minimum length`,
    ROUND(AVG(length), 2) `Average length`
FROM songs
    INNER JOIN albums ON songs.album_id = albums.id
    INNER JOIN bands ON bands.id = albums.band_id
GROUP BY bands.name;

# Retrieve the longest song from each album and sort the results by the length of the longest song on each album
SELECT 
    ANY_VALUE(a.name) album, 
    ANY_VALUE(s.name) song, 
    ROUND(max(length), 2) `the longest song`
FROM songs s 
    JOIN albums a ON s.album_id = a.id 
GROUP BY album_id 
ORDER BY `the longest song` DESC;

# Select the number of Songs for each Band
SELECT 
    b.name, 
    count(s.id) number_of_songs 
FROM bands b, albums a, songs s 
WHERE 
    b.id = a.band_id 
    AND a.id = s.album_id 
GROUP  BY b.name;

# Calculate the average length of songs that come from albums with a release year between 1995 and 2010 and start with the letter 'T' for each band.
SELECT 
    ANY_VALUE(bands.id) ID, 
    bands.name, 
    AVG(songs.length) 'Average length'  
FROM bands
    INNER JOIN albums ON albums.band_id = bands.id
    INNER JOIN songs on albums.id=songs.album_id
where 
    release_year between 1995 AND 2010
    AND songs.name like "T%"
GROUP BY bands.name
ORDER BY 'Average length';

# Select all songs that are shorter than 4 minutes except for those that have the same name as the album.
SELECT songs.*, albums.name FROM songs 
INNER JOIN albums ON songs.album_id = albums.id
INNER JOIN bands ON albums.band_id = bands.id
WHERE songs.length < 4

EXCEPT

SELECT songs.*, albums.name FROM songs 
INNER JOIN albums ON songs.album_id = albums.id
WHERE songs.name = albums.name;

# Retrieve all informations about albums and names of the songs released in period other than between 1998-2010. Order by release year, songs name and albums name
SELECT 
    albums.*, 
    songs.name 
FROM songs 
    INNER JOIN albums ON songs.album_id = albums.id
    INNER JOIN bands ON albums.band_id = bands.id
WHERE albums.release_year Not between '1998' AND '2010'
ORDER BY 
    albums.release_year, 
    songs.name, 
    albums.name;
    
# Delete table songs.
DROP TABLE IF EXISTS songs;

# Delete all records from the table songs.
TRUNCATE TABLE  songs;

# Delete 5 newest albums.
DELETE FROM albums 
ORDER BY release_year DESC LIMIT 5;

# Delete all songs and albums that were released before 1990 or have no release year information.
DELETE songs.* FROM songs 
JOIN albums ON songs.album_id = albums.id
WHERE 
    albums.release_year < '1990'
    OR albums.release_year IS NULL;

DELETE FROM albums
WHERE 
    albums.release_year < '1990'
    OR albums.release_year IS NULL;

# Select songs that are above the average length (in seconds) of all songs in the database, and are released by bands with at least two albums.
select
    bands.name,
    albums.name,
    songs.name,
    ROUND((songs.length * 60), 0) `length in seconds`
FROM songs
    INNER JOIN albums ON songs.album_id = albums.id 
    INNER JOIN bands ON albums.band_id = bands.id
WHERE 
    bands.name IN (
        SELECT DISTINCT bands.name 
        FROM bands
	    JOIN albums ON albums.band_id = bands.id
	WHERE albums.band_id IN (
            SELECT band_id 
            FROM albums 
            GROUP BY band_id 
            having count(*) > 1
            ) 
        )
    AND songs.length > (
	SELECT AVG(length) 
        FROM songs);
