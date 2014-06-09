SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `FeedReader` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `FeedReader` ;

-- -----------------------------------------------------
-- Table `FeedReader`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NULL,
  `password` VARCHAR(64) NULL,
  `email` VARCHAR(40) NULL,
  `salt` VARCHAR(64) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`sites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`sites` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NULL,
  `url` VARCHAR(255) NULL,
  `last_load_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `url_UNIQUE` (`url` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`articles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`articles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `site_id` INT NULL,
  `title` VARCHAR(255) NULL,
  `content` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_idx` (`site_id` ASC),
  CONSTRAINT `articles_site_id`
    FOREIGN KEY (`site_id`)
    REFERENCES `FeedReader`.`sites` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`comments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `article_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `content` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `article_id_idx` (`article_id` ASC),
  INDEX `user_id_idx` (`user_id` ASC),
  CONSTRAINT `comments_article_id`
    FOREIGN KEY (`article_id`)
    REFERENCES `FeedReader`.`articles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `comments_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `FeedReader`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`rel_users_subscribe_sites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`rel_users_subscribe_sites` (
  `user_id` INT NOT NULL,
  `site_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `site_id`),
  INDEX `fk_users_has_sites_sites1_idx` (`site_id` ASC),
  INDEX `fk_users_has_sites_users1_idx` (`user_id` ASC),
  CONSTRAINT `sites_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `FeedReader`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sites_site_id`
    FOREIGN KEY (`site_id`)
    REFERENCES `FeedReader`.`sites` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`rel_users_star_articles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`rel_users_star_articles` (
  `user_id` INT NOT NULL,
  `article_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `article_id`),
  INDEX `fk_users_has_articles_articles1_idx` (`article_id` ASC),
  INDEX `fk_users_has_articles_users1_idx` (`user_id` ASC),
  CONSTRAINT `star_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `FeedReader`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `star_article_id`
    FOREIGN KEY (`article_id`)
    REFERENCES `FeedReader`.`articles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`rel_users_like_articles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`rel_users_like_articles` (
  `user_id` INT NOT NULL,
  `article_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `article_id`),
  INDEX `fk_users_has_articles_articles2_idx` (`article_id` ASC),
  INDEX `fk_users_has_articles_users2_idx` (`user_id` ASC),
  CONSTRAINT `like_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `FeedReader`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `like_article_id`
    FOREIGN KEY (`article_id`)
    REFERENCES `FeedReader`.`articles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`rel_users_follow_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`rel_users_follow_users` (
  `user1_id` INT NOT NULL,
  `user2_id` INT NOT NULL,
  PRIMARY KEY (`user1_id`, `user2_id`),
  INDEX `fk_users_has_users_users2_idx` (`user2_id` ASC),
  INDEX `fk_users_has_users_users1_idx` (`user1_id` ASC),
  CONSTRAINT `follow_user1_id`
    FOREIGN KEY (`user1_id`)
    REFERENCES `FeedReader`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `follow_user2_id`
    FOREIGN KEY (`user2_id`)
    REFERENCES `FeedReader`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`rel_users_read_articles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`rel_users_read_articles` (
  `user_id` INT NOT NULL,
  `article_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `article_id`),
  INDEX `fk_users_has_articles_articles3_idx` (`article_id` ASC),
  INDEX `fk_users_has_articles_users3_idx` (`user_id` ASC),
  CONSTRAINT `read_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `FeedReader`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `read_article_id`
    FOREIGN KEY (`article_id`)
    REFERENCES `FeedReader`.`articles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(20) NULL,
  UNIQUE INDEX `text_UNIQUE` (`text` ASC),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FeedReader`.`rel_users_tags_sites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FeedReader`.`rel_users_tags_sites` (
  `user_id` INT NOT NULL,
  `site_id` INT NOT NULL,
  `tag_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `site_id`, `tag_id`),
  INDEX `fk_users_has_sites_sites2_idx` (`site_id` ASC),
  INDEX `fk_users_has_sites_users2_idx` (`user_id` ASC),
  INDEX `tag_id_idx` (`tag_id` ASC),
  CONSTRAINT `tags_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `FeedReader`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `tags_site_id`
    FOREIGN KEY (`site_id`)
    REFERENCES `FeedReader`.`sites` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `tags_tag_id`
    FOREIGN KEY (`tag_id`)
    REFERENCES `FeedReader`.`tags` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
