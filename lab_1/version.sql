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
    `terms_id` INT(11) NULL,
    `description` VARCHAR(255),
    `version` VARCHAR(5) NOT NULL,
    `source` VARCHAR(255) NOT NULL DEFAULT 'google.com',
    PRIMARY KEY (`id`)    
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Author` (
    `id` INT (11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY (`id`)
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
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `software_id` INT(11) NOT NULL,
    `start` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `end` TIMESTAMP NULL,
    `info` VARCHAR(127),
    PRIMARY KEY (`id`),
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

ALTER TABLE `Software`
    ADD CONSTRAINT `fk_software_terms` FOREIGN KEY (`terms_id`)
        REFERENCES `Terms` (`id`) ON DELETE SET NULL;

INSERT `Users`(`login`, `password`)
VALUES
('first', '1');