/* DBユーザー作成 */
CREATE USER 'recipe_user'@'localhost' IDENTIFIED BY 'P@ssw0rd';

/* DBユーザーの権限設定 */
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, REFERENCES ON recipe.* TO 'recipe_user'@'localhost';

/* データベース作成 */
CREATE DATABASE recipe;

/* recipeデータベースに接続 */
use recipe;