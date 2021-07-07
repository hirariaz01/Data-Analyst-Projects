-- This SQL file contains sql quries for Instagram Analysis

-- Top 5 oldest users 
SELECT * FROM users
ORDER BY created_at
LIMIT 5;


-- What day of the week do most users register on
SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;


-- Users who have never posted a photo
SELECT username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;


-- Who got most likes
SELECT users.username,photos.id,photos.image_url,COUNT(*) AS Total_Likes
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = likes.user_id
GROUP BY photos.id
ORDER BY Total_Likes DESC
LIMIT 1;


-- How many times does the average user post?
-- total number of photos/total number of users
SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2);


-- user ranking by postings higher to lower
SELECT users.username,COUNT(photos.image_url)
FROM users
JOIN photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;


-- Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) 
SELECT SUM(user_posts.total_posts_per_user)
FROM (SELECT users.username,COUNT(photos.image_url) AS total_posts_per_user
		FROM users
		JOIN photos ON users.id = photos.user_id
		GROUP BY users.id) AS user_posts;


-- Total numbers of users who have posted at least one time 
SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
JOIN photos ON users.id = photos.user_id;


-- What are the top 5 most commonly used hashtags
SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC;


-- Users who have liked every single photo on the site
SELECT users.id,username, COUNT(users.id) As total_likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos);


-- Users who have never commented on a photo
SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL;


-- Users who have ever commented on a photo
SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NOT NULL;


-- Percentage of our users who have either never commented on a photo or have commented on photos before
SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who commented on photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
	)AS tableB