SELECT
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
  COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
  COALESCE(SUM(sa.confirmed_amount), 0) / 100 AS total_deposits
FROM
  users_customuser u
JOIN
  plans_plan p ON p.owner_id = u.id AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
JOIN
  savings_savingsaccount sa ON sa.plan_id = p.id AND sa.confirmed_amount > 0
GROUP BY
  u.id, u.first_name, u.last_name
HAVING
  savings_count > 0
  AND investment_count > 0
ORDER BY
  total_deposits DESC;
