DROP TABLE RelatedNews;
DROP TABLE CategorySubscription;
DROP TABLE Reaction;
DROP TABLE NewsItem;
DROP TABLE Author;
DROP TABLE NewsCategory;
DROP TABLE MailSubscriber;

CREATE TABLE MailSubscriber
(
	id			NUMBER(10,0) PRIMARY KEY,
	firstName		VARCHAR2(64),
	lastName		VARCHAR2(255),
	email			VARCHAR2(128),
	subScriptionType 		VARCHAR2(128),
	lastSentEmail	TIMESTAMP
);

CREATE TABLE NewsCategory
(	
	name			VARCHAR2(64) PRIMARY KEY,
	description		VARCHAR2(2048)
);

CREATE TABLE Author
(	
	id			NUMBER(10,0) PRIMARY KEY,
	firstName		VARCHAR2(64),
	lastName		VARCHAR2(255),
	agency		VARCHAR2(255),
	details			VARCHAR2(2048)
);

CREATE TABLE NewsItem
(	
	id			NUMBER(10,0) PRIMARY KEY,
	placedOn		TIMESTAMP,
	header		VARCHAR2(255),
	body			VARCHAR2(2048),
	sourceLink		VARCHAR2(255),
	NewsCategoryName		VARCHAR2(64) REFERENCES NewsCategory(name),
	AuthorId		NUMBER(10,0) REFERENCES Author(id)
);

CREATE TABLE Reaction
(	
	id			NUMBER(10,0) PRIMARY KEY,
	name			VARCHAR2(64),
	placedOn		TIMESTAMP,
	ipAddress			VARCHAR2(39),
	ReactionText		VARCHAR2(1024),
	visible		NUMBER(1),
	NewsItemId		NUMBER(10,0) REFERENCES NewsItem(id)
);

CREATE TABLE CategorySubscription
(	
	MailSubscriberId		NUMBER(10,0) REFERENCES MailSubscriber(id),
	NewsCategoryName		VARCHAR2(64) REFERENCES NewsCategory(name),
	PRIMARY KEY (MailSubscriberId,NewsCategoryName)
);

CREATE TABLE RelatedNews
(	
	NewsItemId			NUMBER(10,0) REFERENCES NewsItem(id),
	RelatedNewsItemId	NUMBER(10,0) REFERENCES NewsItem(id),
	PRIMARY KEY (NewsItemId,RelatedNewsItemId)
);