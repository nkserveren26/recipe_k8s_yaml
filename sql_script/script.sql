/* DBユーザー作成 */
CREATE USER 'recipe_user'@'localhost' IDENTIFIED BY 'P@ssw0rd';

/* DBユーザーの権限設定 */
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, REFERENCES ON recipe.* TO 'recipe_user'@'localhost';

/* 開発環境のMySQLデータのダンプファイルを作成 */
mysqldump -u root -p recipe > recipe.sql

/* インポート先環境でデータベースを作成 */
sudo mysql -e "CREATE DATABASE recipe"

/* インポート実施 (rootユーザーの認証方式は「auth_socket」となっているため、OSユーザーのrootとして接続) */
sudo mysql recipe < /tmp/recipe.sql

/* DBユーザー作成 */
CREATE USER 'recipe_user'@'%' IDENTIFIED BY 'P@ssw0rd';

/* 権限を付与（必要に応じて調整） */
GRANT SELECT, INSERT, UPDATE, DELETE ON recipe.* TO 'recipe_user'@'%';

/* MySQL で外部からの接続を許可。下記のファイルのbind-addressに「0.0.0.0」を指定 */
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf

/* MySQL 再起動 */
sudo systemctl restart mysql