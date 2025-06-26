/* DBユーザー作成 */
CREATE USER 'recipe_user'@'localhost' IDENTIFIED BY 'P@ssw0rd';

/* DBユーザーの権限設定 */
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, REFERENCES ON recipe.* TO 'recipe_user'@'localhost';

/* データベース作成 */
CREATE DATABASE recipe;

/* recipeデータベースに接続 */
use recipe;

/* categoriesテーブル作成 */
CREATE TABLE category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);


/* recipesテーブル作成 */
CREATE TABLE recipe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    title VARCHAR(255) NOT NULL,
    servings INT NOT NULL,
    image VARCHAR(2000) NOT NULL,
    video_url VARCHAR(2000) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

/* recipe_stepテーブル作成 */
CREATE TABLE recipe_step (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    step_number INT NOT NULL,
    description VARCHAR(400) NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipe(id) ON DELETE CASCADE
);

/* recipe_ingredientテーブル作成 */
CREATE TABLE recipe_ingredient (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    amount VARCHAR(100) NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipe(id) ON DELETE CASCADE
);

/* recipe_pointテーブル作成 */
CREATE TABLE recipe_point (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    point VARCHAR(400) NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipe(id) ON DELETE CASCADE
);