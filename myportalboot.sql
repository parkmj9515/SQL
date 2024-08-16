CREATE TABLE myportalboot (
    no long PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    hit BIGINT,
    regDate DATETIME,
    userNo BIGINT,
    userName VARCHAR(255),
    fileName VARCHAR(255),
    filePath TEXT
);