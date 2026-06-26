-- MoeNews 补充种子数据脚本
-- 使用前请先执行 sql/init.sql 创建数据库和基础表。
-- 本脚本可重复执行：每次执行会先清理上一轮以“种子数据/种子分类/seed_”标识的数据。

USE moenews;

SET NAMES utf8mb4;
SET @seed_password = '$2a$10$j0R.JHtEqs5J37OxGzGO9OvDZeLTiOdCe95W.eAOuc3Fd8mDAUidC';

-- 先清理旧种子数据，避免多次执行后数据重复。
DELETE nc
FROM news_comment nc
JOIN news n ON nc.news_id = n.id
WHERE n.title LIKE '种子数据-%';

DELETE FROM news_comment
WHERE content LIKE '[种子数据]%';

DELETE FROM news
WHERE title LIKE '种子数据-%';

DELETE FROM news_category
WHERE name LIKE '种子分类-%';

DELETE FROM user
WHERE username LIKE 'seed_%';

-- 用户数据：覆盖管理员、普通用户、启用、禁用等场景。
INSERT INTO user (username, password, nickname, email, phone, role, status, create_time, update_time) VALUES
('seed_admin_ops', @seed_password, '运营管理员', 'ops@moenews.test', '13800001001', 'ADMIN', 1, DATE_SUB(NOW(), INTERVAL 80 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('seed_admin_audit', @seed_password, '审核管理员', 'audit@moenews.test', '13800001002', 'ADMIN', 1, DATE_SUB(NOW(), INTERVAL 70 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('seed_admin_disabled', @seed_password, '停用管理员', 'disabled-admin@moenews.test', '13800001003', 'ADMIN', 0, DATE_SUB(NOW(), INTERVAL 60 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('seed_user_01', @seed_password, '晨间读者', 'reader01@moenews.test', '13800002001', 'USER', 1, DATE_SUB(NOW(), INTERVAL 55 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('seed_user_02', @seed_password, '校园观察员', 'reader02@moenews.test', '13800002002', 'USER', 1, DATE_SUB(NOW(), INTERVAL 53 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('seed_user_03', @seed_password, '技术同学', 'reader03@moenews.test', '13800002003', 'USER', 1, DATE_SUB(NOW(), INTERVAL 51 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('seed_user_04', @seed_password, '社团小编', 'reader04@moenews.test', '13800002004', 'USER', 1, DATE_SUB(NOW(), INTERVAL 49 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('seed_user_05', @seed_password, '图书馆常客', 'reader05@moenews.test', '13800002005', 'USER', 1, DATE_SUB(NOW(), INTERVAL 47 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('seed_user_06', @seed_password, '竞赛达人', 'reader06@moenews.test', '13800002006', 'USER', 1, DATE_SUB(NOW(), INTERVAL 45 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY)),
('seed_user_07', @seed_password, '实习记录者', 'reader07@moenews.test', '13800002007', 'USER', 1, DATE_SUB(NOW(), INTERVAL 43 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),
('seed_user_08', @seed_password, '摄影爱好者', 'reader08@moenews.test', '13800002008', 'USER', 1, DATE_SUB(NOW(), INTERVAL 41 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY)),
('seed_user_09', @seed_password, '运动打卡人', 'reader09@moenews.test', '13800002009', 'USER', 1, DATE_SUB(NOW(), INTERVAL 39 DAY), DATE_SUB(NOW(), INTERVAL 9 DAY)),
('seed_user_10', @seed_password, '后勤体验官', 'reader10@moenews.test', '13800002010', 'USER', 1, DATE_SUB(NOW(), INTERVAL 37 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
('seed_user_11', @seed_password, '毕业生代表', 'reader11@moenews.test', '13800002011', 'USER', 1, DATE_SUB(NOW(), INTERVAL 35 DAY), DATE_SUB(NOW(), INTERVAL 11 DAY)),
('seed_user_12', @seed_password, '夜读同学', 'reader12@moenews.test', '13800002012', 'USER', 1, DATE_SUB(NOW(), INTERVAL 33 DAY), DATE_SUB(NOW(), INTERVAL 12 DAY)),
('seed_user_disabled_01', @seed_password, '禁用读者一号', 'disabled01@moenews.test', '13800002901', 'USER', 0, DATE_SUB(NOW(), INTERVAL 31 DAY), DATE_SUB(NOW(), INTERVAL 13 DAY)),
('seed_user_disabled_02', @seed_password, '禁用读者二号', 'disabled02@moenews.test', '13800002902', 'USER', 0, DATE_SUB(NOW(), INTERVAL 29 DAY), DATE_SUB(NOW(), INTERVAL 14 DAY));

-- 分类数据：覆盖启用、禁用、排序、专题类目等场景。
INSERT INTO news_category (name, description, sort, status, create_time, update_time) VALUES
('种子分类-校园', '校园通知、院系动态、迎新毕业等内容', 101, 1, DATE_SUB(NOW(), INTERVAL 45 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('种子分类-科技', '软件、硬件、人工智能与实验室成果', 102, 1, DATE_SUB(NOW(), INTERVAL 44 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('种子分类-社团', '学生社团、讲座、志愿活动与文化节', 103, 1, DATE_SUB(NOW(), INTERVAL 43 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('种子分类-就业', '招聘、实习、校友经验和职业发展', 104, 1, DATE_SUB(NOW(), INTERVAL 42 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('种子分类-竞赛', '学科竞赛、创新创业和获奖资讯', 105, 1, DATE_SUB(NOW(), INTERVAL 41 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('种子分类-生活', '食堂、宿舍、交通、服务与校园生活', 106, 1, DATE_SUB(NOW(), INTERVAL 40 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY)),
('种子分类-公告', '系统公告、维护通知和重要提醒', 107, 1, DATE_SUB(NOW(), INTERVAL 39 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),
('种子分类-人物', '教师、学生、校友人物故事', 108, 1, DATE_SUB(NOW(), INTERVAL 38 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY)),
('种子分类-归档', '历史归档分类，当前禁用', 201, 0, DATE_SUB(NOW(), INTERVAL 37 DAY), DATE_SUB(NOW(), INTERVAL 9 DAY)),
('种子分类-测试禁用', '用于验证禁用分类不能发布新闻', 202, 0, DATE_SUB(NOW(), INTERVAL 36 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY));

DROP TEMPORARY TABLE IF EXISTS seed_news_blueprint;
CREATE TEMPORARY TABLE seed_news_blueprint (
  category_name VARCHAR(50) NOT NULL,
  author_username VARCHAR(50) NOT NULL,
  title VARCHAR(150) NOT NULL,
  summary VARCHAR(500) NOT NULL,
  status TINYINT NOT NULL,
  view_count BIGINT NOT NULL,
  days_ago INT NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 新闻数据：status 0=草稿，1=已发布，2=已下架。覆盖多个分类、作者、时间和浏览量。
INSERT INTO seed_news_blueprint (category_name, author_username, title, summary, status, view_count, days_ago) VALUES
('种子分类-校园', 'admin', '种子数据-校园迎新服务站正式开放', '迎新服务站提供报到指引、校园地图、宿舍咨询和志愿者协助。', 1, 328, 1),
('种子分类-校园', 'seed_admin_ops', '种子数据-图书馆延长晚间开放时间', '图书馆将在考试周期间延长开放时间，方便学生复习。', 1, 286, 2),
('种子分类-校园', 'seed_admin_ops', '种子数据-教学楼空调检修安排', '后勤部门将分区域开展教学楼空调检修，请师生留意通知。', 1, 142, 3),
('种子分类-校园', 'seed_admin_audit', '种子数据-校园一卡通服务升级草稿', '一卡通系统升级方案仍在整理中，暂不对外发布。', 0, 18, 4),
('种子分类-校园', 'seed_admin_audit', '种子数据-旧版校历通知已下架', '旧版校历通知已被新版安排替换。', 2, 91, 20),
('种子分类-科技', 'admin', '种子数据-AI 实验室开放体验日', '人工智能实验室面向学生开放体验，展示模型训练和应用案例。', 1, 512, 1),
('种子分类-科技', 'seed_admin_ops', '种子数据-软件工程课程项目展示', '多个课程项目集中展示，覆盖 Web、移动端和数据分析方向。', 1, 448, 2),
('种子分类-科技', 'seed_admin_audit', '种子数据-校园网络 IPv6 优化完成', '校园网络完成 IPv6 访问优化，部分区域访问速度提升。', 1, 377, 3),
('种子分类-科技', 'admin', '种子数据-服务器维护窗口草稿', '服务器维护时间仍待确认，暂存为草稿。', 0, 34, 5),
('种子分类-科技', 'seed_admin_ops', '种子数据-旧版实验室预约入口下架', '旧版预约入口已迁移到新版统一平台。', 2, 123, 28),
('种子分类-社团', 'seed_admin_ops', '种子数据-社团招新周活动预告', '社团招新周将在中心广场举行，覆盖文艺、体育、公益等方向。', 1, 263, 2),
('种子分类-社团', 'seed_admin_audit', '种子数据-摄影社校园影展开展', '摄影社展出校园四季主题作品，欢迎师生参观。', 1, 234, 4),
('种子分类-社团', 'admin', '种子数据-志愿服务队周末活动', '志愿服务队将开展社区服务和图书整理活动。', 1, 198, 5),
('种子分类-社团', 'seed_admin_ops', '种子数据-社团活动场地申请草稿', '场地申请规则仍在审核，暂不发布。', 0, 25, 6),
('种子分类-社团', 'seed_admin_audit', '种子数据-过期讲座报名链接下架', '讲座报名已结束，相关链接下架。', 2, 88, 30),
('种子分类-就业', 'seed_admin_audit', '种子数据-春季双选会企业名单公布', '本次双选会覆盖互联网、制造、金融和教育行业。', 1, 621, 1),
('种子分类-就业', 'admin', '种子数据-校友分享实习转正经验', '校友从简历准备、面试节奏和项目复盘三个角度分享经验。', 1, 470, 2),
('种子分类-就业', 'seed_admin_ops', '种子数据-简历门诊预约开放', '就业指导中心开放简历门诊预约，为学生提供一对一修改建议。', 1, 398, 3),
('种子分类-就业', 'seed_admin_audit', '种子数据-企业宣讲会排期草稿', '企业宣讲会排期仍在确认，暂不发布。', 0, 42, 5),
('种子分类-就业', 'admin', '种子数据-过期招聘信息下架', '相关招聘岗位已截止投递。', 2, 176, 18),
('种子分类-竞赛', 'admin', '种子数据-程序设计竞赛报名启动', '程序设计竞赛报名启动，支持个人和团队报名。', 1, 534, 1),
('种子分类-竞赛', 'seed_admin_ops', '种子数据-创新创业训练项目立项', '创新创业训练项目完成评审，多支团队获得立项。', 1, 409, 3),
('种子分类-竞赛', 'seed_admin_audit', '种子数据-数学建模赛前培训安排', '赛前培训将围绕建模方法、论文写作和工具使用展开。', 1, 366, 4),
('种子分类-竞赛', 'admin', '种子数据-竞赛获奖名单复核草稿', '获奖名单仍在复核，暂不发布。', 0, 51, 6),
('种子分类-竞赛', 'seed_admin_ops', '种子数据-旧版报名规则下架', '旧版竞赛报名规则已由新版替代。', 2, 115, 24),
('种子分类-生活', 'seed_admin_ops', '种子数据-食堂新增自助结算通道', '食堂新增自助结算通道，减少高峰期排队时间。', 1, 289, 2),
('种子分类-生活', 'seed_admin_audit', '种子数据-宿舍热水系统维护提醒', '宿舍热水系统将在夜间维护，请同学提前做好安排。', 1, 256, 3),
('种子分类-生活', 'admin', '种子数据-校园巴士运行时间调整', '校园巴士工作日早晚高峰增加班次。', 1, 331, 4),
('种子分类-生活', 'seed_admin_ops', '种子数据-失物招领系统优化草稿', '失物招领系统优化方案仍在测试。', 0, 39, 7),
('种子分类-生活', 'seed_admin_audit', '种子数据-临时维修通知下架', '临时维修已完成，通知下架。', 2, 109, 16),
('种子分类-公告', 'admin', '种子数据-系统维护公告', '新闻系统将在凌晨进行短时维护，请管理员提前保存内容。', 1, 187, 1),
('种子分类-公告', 'seed_admin_ops', '种子数据-账号安全提醒', '请用户定期检查密码安全，不要向他人泄露登录信息。', 1, 233, 2),
('种子分类-公告', 'seed_admin_audit', '种子数据-图片上传规范说明', '新闻封面建议使用横向图片，文件大小不超过 2MB。', 1, 202, 3),
('种子分类-公告', 'admin', '种子数据-后台菜单调整草稿', '后台菜单调整方案仍在评估。', 0, 44, 5),
('种子分类-公告', 'seed_admin_ops', '种子数据-旧维护公告下架', '旧维护公告已过期，下架归档。', 2, 70, 25),
('种子分类-人物', 'seed_admin_audit', '种子数据-优秀学生科研故事', '优秀学生分享科研训练、论文阅读和项目协作经验。', 1, 390, 2),
('种子分类-人物', 'admin', '种子数据-青年教师课堂观察', '青年教师围绕课程设计和课堂互动分享教学心得。', 1, 342, 4),
('种子分类-人物', 'seed_admin_ops', '种子数据-校友创业访谈', '校友讲述从校园项目到创业团队的成长过程。', 1, 421, 6),
('种子分类-归档', 'admin', '种子数据-归档分类历史新闻', '该新闻用于验证禁用分类和下架新闻在后台的展示效果。', 2, 96, 60),
('种子分类-测试禁用', 'seed_admin_audit', '种子数据-禁用分类草稿新闻', '该草稿用于验证禁用分类相关数据不会进入前台。', 0, 12, 61);

INSERT INTO news (
  title,
  summary,
  content,
  cover_image,
  category_id,
  author_id,
  status,
  view_count,
  create_time,
  update_time
)
SELECT
  b.title,
  b.summary,
  CONCAT(
    '# ', b.title, '\n\n',
    b.summary, '\n\n',
    '## 详情\n\n',
    '这是一条用于课程设计演示和系统测试的补充新闻。它覆盖分类筛选、状态筛选、分页、浏览量、Markdown 渲染等场景。\n\n',
    '- 分类：', b.category_name, '\n',
    '- 作者：', u.nickname, '\n',
    '- 状态值：', b.status, '\n\n',
    '> 本内容由 `sql/seed_data.sql` 自动生成。'
  ) AS content,
  NULL AS cover_image,
  c.id AS category_id,
  u.id AS author_id,
  b.status,
  b.view_count,
  DATE_SUB(NOW(), INTERVAL b.days_ago DAY),
  DATE_SUB(NOW(), INTERVAL b.days_ago DAY)
FROM seed_news_blueprint b
JOIN news_category c ON c.name COLLATE utf8mb4_unicode_ci = b.category_name COLLATE utf8mb4_unicode_ci
JOIN user u ON u.username COLLATE utf8mb4_unicode_ci = b.author_username COLLATE utf8mb4_unicode_ci;

DROP TEMPORARY TABLE IF EXISTS seed_comment_blueprint;
CREATE TEMPORARY TABLE seed_comment_blueprint (
  username VARCHAR(50) NOT NULL,
  content VARCHAR(500) NOT NULL,
  status TINYINT NOT NULL,
  hour_offset INT NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 评论数据：为所有已发布种子新闻生成多条评论，覆盖显示和隐藏状态。
INSERT INTO seed_comment_blueprint (username, content, status, hour_offset) VALUES
('seed_user_01', '[种子数据] 内容很清楚，适合在答辩时演示前台评论列表。', 1, 1),
('seed_user_02', '[种子数据] 这个信息很实用，希望后续能继续更新。', 1, 2),
('seed_user_03', '[种子数据] 已阅读，Markdown 展示效果正常。', 1, 3),
('seed_user_04', '[种子数据] 这条评论用于验证后台隐藏评论功能。', 0, 4),
('seed_user_05', '[种子数据] 分页数据丰富后，列表测试更直观。', 1, 5);

INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT
  n.id,
  u.id,
  CONCAT(cb.content, ' 新闻ID=', n.id),
  cb.status,
  DATE_ADD(n.create_time, INTERVAL cb.hour_offset HOUR),
  DATE_ADD(n.create_time, INTERVAL cb.hour_offset HOUR)
FROM news n
JOIN seed_comment_blueprint cb
JOIN user u ON u.username COLLATE utf8mb4_unicode_ci = cb.username COLLATE utf8mb4_unicode_ci
WHERE n.title LIKE '种子数据-%'
  AND n.status = 1;

DROP TEMPORARY TABLE IF EXISTS seed_news_blueprint;
DROP TEMPORARY TABLE IF EXISTS seed_comment_blueprint;

-- 执行结果统计，便于在命令行确认导入规模。
SELECT 'seed_users' AS item, COUNT(*) AS total FROM user WHERE username LIKE 'seed_%'
UNION ALL
SELECT 'seed_categories', COUNT(*) FROM news_category WHERE name LIKE '种子分类-%'
UNION ALL
SELECT 'seed_news', COUNT(*) FROM news WHERE title LIKE '种子数据-%'
UNION ALL
SELECT 'seed_comments', COUNT(*) FROM news_comment WHERE content LIKE '[种子数据]%';
