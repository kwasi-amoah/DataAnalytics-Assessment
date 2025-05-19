WITH customer_transactions AS (
  SELECT
    sa.owner_id,
    COUNT(*) AS total_transactions,
    MIN(sa.transaction_date) AS first_transaction,
    MAX(sa.transaction_date) AS last_transaction
  FROM savings_savingsaccount sa
  GROUP BY sa.owner_id
),
customer_avg_monthly AS (
  SELECT
    owner_id,
    total_transactions,
    first_transaction,
    last_transaction,
    -- Calculate months difference (at least 1 to avoid division by zero)
    GREATEST(
      TIMESTAMPDIFF(MONTH, first_transaction, last_transaction),
      1
    ) AS months_active,
    total_transactions / GREATEST(
      TIMESTAMPDIFF(MONTH, first_transaction, last_transaction),
      1
    ) AS avg_transactions_per_month
  FROM customer_transactions
),
categorized AS (
  SELECT
    owner_id,
    avg_transactions_per_month,
    CASE
      WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
      WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM customer_avg_monthly
)
SELECT
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY
  CASE frequency_category
    WHEN 'High Frequency' THEN 1
    WHEN 'Medium Frequency' THEN 2
    WHEN 'Low Frequency' THEN 3
  END;
