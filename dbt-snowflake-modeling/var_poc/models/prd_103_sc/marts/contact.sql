{{ config(
    materialized='table',
    schema='processed'
) }}

-- TD元処理: wf_2300_stp_201_contact.sql の完全再現
-- 処理内容: raw_contact テーブルから重複排除処理により最新データを抽出

WITH t2 AS (
  SELECT
    CONCAT("id", '_', CAST(MAX("time") AS VARCHAR)) AS key
  FROM
    {{ source('raw_prd_103_sc', '"raw_contact"') }}
  GROUP BY
    "id"
)
SELECT
  t1.*
FROM
  {{ source('raw_prd_103_sc', '"raw_contact"') }} t1
  INNER JOIN t2 ON CONCAT(t1."id", '_', CAST(t1."time" AS VARCHAR)) = t2.key
