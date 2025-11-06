## データベース設計

### ER図

（ここにER図の画像を挿入すると、より分かりやすくなります）

### テーブル定義

### `users` テーブル

Devise利用を想定したテーブルです。

| カラム名              | データ型   | 概要                        | オプション                           |
| :------------------- | :------- | :------------------------- | :----------------------------------- |
| `id`                 | `bigint` | 主キー                      | `PK`, `AI`, `unsigned`               |
| `email`              | `string` | ログインに使用するメールアドレス | `null: false`, `unique`              |
| `encrypted_password` | `string` | 暗号化されたパスワード         | `null: false`                        |
| `nickname`           | `string` | アプリ内で表示されるニックネーム | `null: false`                        |
| `created_at`         | `datetime`| 作成日時                    | `null: false`                        |
| `updated_at`         | `datetime`| 更新日時                    | `null: false`                        |

### Associations
* `has_many :spots`
* `has_many :hosted_groups, class_name: 'Group', foreign_key: 'host_id'`
* `has_many :group_members`
* `has_many :groups, through: :group_members`
* `has_many :added_candidate_spots, class_name: 'CandidateSpot', foreign_key: 'added_by_user_id'`

### `spots` テーブル

| カラム名             | データ型    | 概要                   | オプション                               |
| :------------------- | :-------- | :--------------------- | :--------------------------------------- |
| `id`                 | `bigint`  | 主キー                 | `PK`, `AI`, `unsigned`                   |
| `user_id`            | `bigint`  | 作成したユーザーのID     | `null: false`, `index`, `FK`             |
| `name`               | `string`  | スポットの正式名称      | `null: false`                            |
| `description`        | `text`    | メモ                   |                                          |
| `latitude`           | `decimal` | 緯度                   | `null: false`, `precision: 10, scale: 7` |
| `longitude`          | `decimal` | 経度                   | `null: false`, `precision: 10, scale: 7` |
| `photo_url`          | `string`  | 写真のURL              |                                          |
| `tags`               | `text`    | 分類や特徴を示すタグ（シリアライズ） |                                          |
| `created_at`         | `datetime`| 作成日時               | `null: false`                            |
| `updated_at`         | `datetime`| 更新日時               | `null: false`                            |

### Associations
* `belongs_to :user`
* `has_many :candidate_spots`

### `groups` テーブル

| カラム名             | データ型    | 概要                      | オプション                               |
| :------------------- | :-------- | :------------------------ | :--------------------------------------- |
| `id`                 | `bigint`  | 主キー                    | `PK`, `AI`, `unsigned`                   |
| `name`               | `string`  | グループの計画名          | `null: false`                            |
| `host_id`            | `bigint`  | 主要な管理者となるユーザーID | `null: false`, `index`, `FK(users.id)`   |
| `description`        | `text`    | 詳細情報                  |                                          |
| `status`             | `string`  | グループの計画状態        | `null: false`                            |
| `created_at`         | `datetime`| 作成日時                  | `null: false`                            |
| `updated_at`         | `datetime`| 更新日時                  | `null: false`                            |

### Associations
* `belongs_to :host, class_name: 'User'`
* `has_many :group_members`
* `has_many :users, through: :group_members`
* `has_many :candidate_spots`

### `group_members` テーブル

中間テーブルです。

| カラム名             | データ型    | 概要               | オプション                               |
| :------------------- | :-------- | :----------------- | :--------------------------------------- |
| `id`                 | `bigint`  | 主キー             | `PK`, `AI`, `unsigned`                   |
| `group_id`           | `bigint`  | グループのID         | `null: false`, `index`, `FK`             |
| `user_id`            | `bigint`  | 参加ユーザーのID     | `null: false`, `index`, `FK`             |
| `role`               | `string`  | グループ内での役割   | `null: false`                            |
| `created_at`         | `datetime`| 作成日時(参加日時)   | `null: false`                            |
| `updated_at`         | `datetime`| 更新日時           | `null: false`                            |

### Associations
* `belongs_to :user`
* `belongs_to :group`

### `candidate_spots` テーブル

中間テーブルです。

| カラム名             | データ型    | 概要                               | オプション                                       |
| :------------------- | :-------- | :--------------------------------- | :----------------------------------------------- |
| `id`                 | `bigint`  | 主キー                             | `PK`, `AI`, `unsigned`                           |
| `group_id`           | `bigint`  | 候補地が属するグループID           | `null: false`, `index`, `FK`                     |
| `spot_id`            | `bigint`  | 候補地として提案された元のスポット | `null: false`, `index`, `FK`                     |
| `added_by_user_id`   | `bigint`  | 提案したユーザー                   | `null: false`, `index`, `FK(users.id)`           |
| `votes`              | `text`    | 投票したユーザーのID配列（シリアライズ） |                                                  |
| `is_decided`         | `boolean` | 最終ルートとして決定されたかのフラグ | `null: false`, `default: false`                  |
| `decided_order`      | `integer` | 訪問順序                           |                                                  |
| `created_at`         | `datetime`| 作成日時                           | `null: false`                                    |
| `updated_at`         | `datetime`| 更新日時                           | `null: false`                                    |

### Associations
* `belongs_to :group`
* `belongs_to :spot`
* `belongs_to :added_by, class_name: 'User', foreign_key: 'added_by_user_id'`