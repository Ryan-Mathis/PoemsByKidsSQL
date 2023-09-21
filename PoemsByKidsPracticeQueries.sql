-- What grades are stored in the database?
SELECT name FROM Grade;
-- What emotions may be associated with a poem?
SELECT name FROM Emotion;
-- How many poems are in the database?
SELECT COUNT(Id) FROM Poem;
-- SELECT COUNT(*) FROM Poem; also works
-- Sort authors alphabetically by name. What are the names of the top 76 authors?
SELECT Name FROM Author ORDER BY Name ASC LIMIT 76;
-- Starting with the above query, add the grade of each of the authors.
SELECT Author.Name AS Author_Name, Grade.Name AS Grade 
FROM Author 
JOIN Grade ON Grade.Id = Author.GradeId
ORDER BY Author.Name ASC LIMIT 76;
-- Starting with the above query, add the recorded gender of each of the authors.
SELECT Author.Name AS Author_Name, Grade.Name AS Grade, Gender.Name AS Gender
FROM Author 
JOIN Grade ON Grade.Id = Author.GradeId
JOIN Gender ON Gender.Id = Author.GenderId
ORDER BY Author.Name ASC LIMIT 76;
-- What is the total number of words in all poems in the database?
SELECT SUM(WordCount) FROM Poem; --374584
-- Which poem has the fewest characters?
SELECT Title, MIN(CharCount) AS Lowest_Character_Count 
FROM Poem 
GROUP BY Title 
ORDER BY Lowest_Character_Count ASC 
LIMIT 1;
-- How many authors are in the third grade?
SELECT COUNT(Author.Id)
FROM Author
JOIN Grade ON Author.GradeId= Grade.Id
WHERE Grade.Name LIKE '%3rd%';
-- other options include WHERE Grade.Name ~* '3rd'; WHERE Grade.Name = '3rd Grade';
-- How many total authors are in the first through third grades?
SELECT COUNT(Author.Id)
FROM Author
JOIN Grade ON Author.GradeId= Grade.Id
WHERE Grade.Name LIKE '%3rd%'
	OR Grade.Name ~* '1st'
	OR Grade.Name ~* '2nd';
-- What is the total number of poems written by fourth graders?
SELECT COUNT(Poem.Id)
FROM Poem
JOIN Author ON Poem.AuthorId = Author.Id
JOIN Grade ON Author.GradeId = Grade.Id
WHERE Grade.Name ~* '4th';
-- How many poems are there per grade?
SELECT Grade.Name, COUNT(Poem.Id)
FROM Poem
JOIN Author ON Poem.AuthorId = Author.Id
JOIN Grade ON Author.GradeId = Grade.Id
GROUP BY Grade.Name
ORDER BY Grade.Name ASC;
-- How many authors are in each grade? (Order your results by grade starting with 1st Grade)
SELECT Grade.Name, COUNT(Author.Id)
FROM Author
JOIN Grade ON Author.GradeId = Grade.Id
GROUP BY Grade.Name
ORDER BY Grade.Name ASC;
-- What is the title of the poem that has the most words?
SELECT Poem.Title
FROM Poem
GROUP BY Title
ORDER BY MAX(WordCount) DESC
LIMIT 1;
-- Which author(s) have the most poems? (Remember authors can have the same name.)
SELECT Author.Name, COUNT(Poem.Id)
FROM Author
JOIN Poem ON Author.Id = Poem.AuthorId
GROUP BY Author.Name, Author.Id
ORDER BY COUNT(Poem.Id) DESC
LIMIT 1;
-- How many poems have an emotion of sadness?
SELECT COUNT(Poem.Id)
FROM Poem
JOIN PoemEmotion ON Poem.Id = PoemEmotion.PoemId
JOIN Emotion ON PoemEmotion.EmotionId = Emotion.Id
WHERE Emotion.Name ~* 'sadness';
-- How many poems are not associated with any emotion?
SELECT COUNT(Poem.Id)
FROM Poem
LEFT JOIN PoemEmotion ON Poem.Id = PoemEmotion.PoemId
WHERE PoemEmotion.emotionId IS NULL;
-- Which emotion is associated with the least number of poems?
SELECT Emotion.Name
FROM Emotion
LEFT JOIN PoemEmotion ON Emotion.Id = PoemEmotion.EmotionId
GROUP BY Emotion.Name
ORDER BY COUNT(PoemEmotion.EmotionId) ASC
LIMIT 1;
-- Which grade has the largest number of poems with an emotion of joy?
SELECT Grade.Name
FROM Grade
JOIN Author ON Grade.Id = Author.GradeId
JOIN Poem ON Poem.AuthorId = Author.Id
JOIN PoemEmotion ON PoemEmotion.PoemId = Poem.Id
JOIN Emotion ON Emotion.Id = PoemEmotion.EmotionId
GROUP BY Grade.Name, Emotion.Name
HAVING Emotion.Name ~* 'joy'
ORDER BY COUNT(Emotion.Name) DESC
LIMIT 1;
-- Which gender has the least number of poems with an emotion of fear?
SELECT Gender.Name
FROM Gender
JOIN Author ON Gender.Id = Author.GenderId
JOIN Poem ON Poem.AuthorId = Author.Id
JOIN PoemEmotion ON PoemEmotion.PoemId = Poem.Id
JOIN Emotion ON Emotion.Id = PoemEmotion.EmotionId
GROUP BY Gender.Name, Emotion.Name
HAVING Emotion.Name ~* 'fear'
ORDER BY COUNT(Emotion.Name) ASC
LIMIT 1;