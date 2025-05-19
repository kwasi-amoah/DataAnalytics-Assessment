WITH customer_summary AS (
  SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
    AVG(sa.confirmed_amount) AS avg_transaction_value -- in kobo
  FROM users_customuser u
  LEFT JOIN savings_savingsaccount sa ON sa.owner_id = u.id
  GROUP BY u.id, u.first_name, u.last_name, u.date_joined
)
SELECT
  customer_id,
  name,
  tenure_months,
  total_transactions,
  ROUND(
    (total_transactions / GREATEST(tenure_months, 1)) * 12 * (avg_transaction_value * 0.001) / 100,
    2
  ) AS estimated_clv
FROM customer_summary
ORDER BY estimated_clv DESC;
