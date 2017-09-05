DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS students;

CREATE TABLE teachers (
  id INTEGER PRIMARY KEY,
  f_name VARCHAR(255) NOT NULL,
  l_name VARCHAR(255) NOT NULL,
  salary INTEGER NOT NULL
);

CREATE TABLE classes (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  room_number INTEGER,
  teacher_id INTEGER NOT NULL,

  FOREIGN KEY(teacher_id) REFERENCES teacher(id)
);

CREATE TABLE students (
  id INTEGER PRIMARY KEY,
  f_name VARCHAR(255) NOT NULL,
  l_name VARCHAR(255) NOT NULL,
  class_id INTEGER NOT NULL,

  FOREIGN KEY(class_id) REFERENCES class(id)
);



INSERT INTO
  teachers (id, f_name, l_name, salary)
VALUES
  (1, "Arthur", "Rutherford", 46000),
  (2, "Bo", "Lei", 45000),
  (3, "Ilya", "Spitkovsky", 47500),
  (4, "Pradeep", "Singh", 49000);

INSERT INTO
  classes (id, name, room_number, teacher_id)
VALUES
  (1, "English 101", 234, 1),
  (2, "English 203", 331, 1),
  (3, "Physics 101", 442, 2),
  (4, "Computer Engineering 101", 444, 2),
  (5, "Real Analysis", 137, 3),
  (6, "Financial Systems", 512, 4),
  (7, "Econometrics", 523, 4);

INSERT INTO
  students (id, f_name, l_name, class_id)
VALUES
  (1, "Araz", "Aslanian", 1),
  (2, "Afeef", "Sahabdeen", 4),
  (3, "Shintaro", "Hashimoto", 7),
  (4, "Koh", "Terai", 4),
  (5, "Hye", "Seung", 5),
  (6, "Maulik", "Patel", 6),
  (7, "Paul", "Alzate", 3),
  (8, "Thomas", "Seubert", 2);
