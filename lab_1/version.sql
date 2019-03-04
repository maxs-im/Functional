CREATE DATABASE IF NOT EXISTS `haskell`;
USE `haskell`;

CREATE TABLE IF NOT EXISTS `Users` (
    `login` VARCHAR(20) PRIMARY KEY,
    `password` VARCHAR(20) NOT NULL
)
COMMENT='Log in =)'
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `Software` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL,
    `description` VARCHAR(255),
    `version` VARCHAR(5) NOT NULL,
    `source` VARCHAR(255) NOT NULL DEFAULT 'google.com',
    PRIMARY KEY (`id`, `name`)    
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Author` (
    `id` INT (11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY (`id`, `name`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Software_Author` (
    `software_id` INT(11) NOT NULL,
    `author_id` INT(11) NOT NULL,
    PRIMARY KEY (`software_id`, `author_id`),
    CONSTRAINT `fk_sa_software` FOREIGN KEY (`software_id`)
        REFERENCES `Software` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_sa_author` FOREIGN KEY (`author_id`)
        REFERENCES `Author` (`id`) ON DELETE CASCADE    
) 
COMMENT = 'Many to many connection'
ENGINE = InnoDB
;

CREATE TABLE IF NOT EXISTS `Terms` (
    `software_id` INT(11) NOT NULL,
    `start` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `end` TIMESTAMP NULL,
    `info` VARCHAR(127),
    PRIMARY KEY (`software_id`),
    CHECK (`start` < `end`),
    CONSTRAINT `fk_terms_software` FOREIGN KEY (`software_id`)
        REFERENCES `Software` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Using_info` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `software_id` INT(11) NOT NULL,
    `name` VARCHAR(20) NOT NULL,
    `info` VARCHAR(255),
    PRIMARY KEY (`id`),
    INDEX (`software_id`),
    CONSTRAINT `fk_using_info_software` FOREIGN KEY (`software_id`)
        REFERENCES `Software` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB;

/*SOME DEFAULT DATA*/

INSERT `Users`(`login`, `password`)
VALUES
('first', '1');

insert into Author (name)
values ("author 1"), ("author 2");

insert into Software (name, description, version, source)
values ("windows", "win desc", "10.1", "computer"),
("linux", "lin desc", "18.0", "another computer");

insert into Software_Author (software_id, author_id)
select s.id, a.id from Software as s inner join Author as a on a.name like 'author%' where s.name = "windows";

insert into Using_info (software_id, name, info)
select id, "student IC-4", "for fun" from Software where name = "windows"; 

insert into Terms (software_id, info)
select id, "some interesting term" from Software where name = "linux";