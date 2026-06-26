CREATE DATABASE IF NOT EXISTS moenews DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE moenews;

DROP TABLE IF EXISTS news_comment;
DROP TABLE IF EXISTS news;
DROP TABLE IF EXISTS news_category;
DROP TABLE IF EXISTS user;

CREATE TABLE user (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(100) NOT NULL,
  nickname VARCHAR(50) NOT NULL,
  email VARCHAR(100) NULL,
  phone VARCHAR(20) NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'USER',
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted TINYINT NOT NULL DEFAULT 0,
  UNIQUE KEY uk_user_username (username),
  KEY idx_user_role (role),
  KEY idx_user_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE news_category (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NULL,
  sort INT NOT NULL DEFAULT 0,
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted TINYINT NOT NULL DEFAULT 0,
  UNIQUE KEY uk_category_name (name),
  KEY idx_category_status (status),
  KEY idx_category_sort (sort)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE news (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(150) NOT NULL,
  summary VARCHAR(500) NULL,
  content MEDIUMTEXT NOT NULL,
  cover_image VARCHAR(255) NULL,
  category_id BIGINT NOT NULL,
  author_id BIGINT NOT NULL,
  status TINYINT NOT NULL DEFAULT 0,
  view_count BIGINT NOT NULL DEFAULT 0,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_news_title (title),
  KEY idx_news_category (category_id),
  KEY idx_news_author (author_id),
  KEY idx_news_status (status),
  KEY idx_news_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE news_comment (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  news_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  content VARCHAR(500) NOT NULL,
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_comment_news (news_id),
  KEY idx_comment_user (user_id),
  KEY idx_comment_status (status),
  KEY idx_comment_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO user (username, password, nickname, role, status) VALUES
('admin', '$2a$10$j0R.JHtEqs5J37OxGzGO9OvDZeLTiOdCe95W.eAOuc3Fd8mDAUidC', '系统管理员', 'ADMIN', 1),
('user', '$2a$10$j0R.JHtEqs5J37OxGzGO9OvDZeLTiOdCe95W.eAOuc3Fd8mDAUidC', '普通用户', 'USER', 1);

INSERT INTO news_category (name, description, sort, status) VALUES
('校园新闻', '校园动态与通知', 10, 1),
('科技资讯', '科技行业新闻', 20, 1),
('生活周边', '生活服务与趣闻', 30, 1);

INSERT INTO news (title, summary, content, category_id, author_id, status, view_count) VALUES
('欢迎使用 MoeNews', '这是系统初始化后自动创建的第一条新闻。', '# 欢迎使用 MoeNews\n\n管理员可以在后台使用 Markdown 编辑新闻正文。', 1, 1, 1, 0);
