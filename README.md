# Coffee Shop Sales Analysis — Power BI & MySQL

## Overview

This project performs a comprehensive business analysis of coffee shop sales data using **Power BI** for interactive dashboarding and **MySQL 8.0** for data cleaning and querying.

The goal is to uncover key sales trends, identify top-performing products and locations, and provide actionable insights for revenue optimization and operational decision-making across multiple store locations.

---

## Power BI Dashboard

An interactive Power BI report (`.pbix`) visualizes the full coffee shop sales story, enabling users to slice and dice the data across dimensions such as:

- **Time:** Monthly/weekly/daily sales trends, hour-of-day patterns, weekday vs. weekend comparisons
- **Product:** Revenue by category and product type, top-selling items
- **Location:** Sales breakdown across store locations
- **KPI Cards:** Total sales, order volume, quantity sold, and month-over-month growth

### Key Metrics Visualized

| Metric | Description |
|--------|-------------|
| **Total Sales** | Aggregate revenue (`unit_price × transaction_qty`) |
| **Total Orders** | Count of transactions per period |
| **Quantity Sold** | Total units sold |
| **MoM Growth** | Month-over-month sales and order growth (%) |
| **Daily Average** | Average daily sales across the selected period |

### Desktop Screenshot

Below is a preview of the full dashboard as rendered on desktop:

![Dashboard Preview](https://github.com/VinsonYuxuanLiang/Coffee_Shop_Sales_MYSQL-PowerBI/blob/main/Dasktop.png)

---

## Dataset

The data is sourced from a coffee shop transactional dataset covering multiple stores and product categories.

- **Dataset Link:** [Sales Data](https://www.kaggle.com/datasets/ahmedabbas757/coffee-sales?resource=download)
- **Raw File:** `Coffee Shop Sales.csv`

### Schema

| Column | Type | Description |
|--------|------|-------------|
| `transaction_id` | INT | Unique transaction identifier |
| `transaction_date` | DATE | Date of transaction |
| `transaction_time` | TIME | Time of transaction |
| `transaction_qty` | INT | Quantity of items purchased |
| `store_id` | INT | Store identifier |
| `store_location` | VARCHAR | Geographic location of the store |
| `product_id` | INT | Product identifier |
| `unit_price` | DECIMAL | Price per unit |
| `product_category` | VARCHAR | Product category (e.g., Coffee) |
| `product_type` | VARCHAR | Specific product type (e.g., Gourmet brewed coffee) |
| `product_detail` | VARCHAR | Product detail (e.g., Ethiopia Rg) |

---

## SQL Queries

All queries are written in **MySQL 8.0** and stored in `coffee.sql`.

### Phase 1 — Data Cleaning & Table Preparation

| Query | Description |
|-------|-------------|
| Q1 | Format `transaction_date` from string to proper date |
| Q2 | Alter `transaction_date` column type to `DATE` |
| Q3 | Format `transaction_time` from string to proper time |
| Q4 | Alter `transaction_time` column type to `TIME` |
| Q5 | Verify schema — inspect column names and data types |
| Q6 | Fix corrupted column headers (e.g., remove BOM prefix) |

### Phase 2 — Core KPIs

| Query | Description |
|-------|-------------|
| Q7 | Monthly total sales (May) |
| Q8 | Sales MoM growth — difference and percentage (April vs May) |
| Q9 | Monthly total orders (May) |
| Q10 | Orders MoM growth — difference and percentage (April vs May) |
| Q11 | Monthly total quantity sold (May) |
| Q12 | Quantity sold MoM growth — difference and percentage (April vs May) |

### Phase 3 — Calendar & Daily Performance

| Query | Description |
|-------|-------------|
| Q13 | Daily KPI snapshot for a specific date (May 18, 2023) |
| Q14 | Formatted daily KPI values (rounded "K" display) |
| Q15 | Average daily sales across all days in May |
| Q16 | Daily sales breakdown for May |
| Q17 | Sales vs. average — each day compared to monthly daily average |

### Phase 4 — Categorical & Dimensional Analysis

| Query | Description |
|-------|-------------|
| Q18 | Weekday vs. weekend sales comparison |
| Q19 | Sales by store location (ranked) |
| Q20 | Sales by product category |
| Q21 | Top 10 products by sales in May |

### Phase 5 — Time & Schedule Patterns

| Query | Description |
|-------|-------------|
| Q22 | Sales by specific day & hour combination |
| Q23 | Sales by day of week (Mon–Sun) |
| Q24 | Sales by hour of day (6 AM – 8 PM) |

---

## Key Findings

1. **Peak Sales Hours:** Morning hours (8–10 AM) drive the highest revenue, indicating a strong breakfast/coffee crowd.
2. **Top Location:** One store location consistently outperforms others — worth investigating foot traffic and marketing.
3. **Best-Selling Product:** A single product category dominates revenue; opportunities exist in cross-selling underperforming categories.
4. **Weekend Surge:** Weekend sales significantly exceed weekday performance, suggesting staffing and inventory adjustments.
5. **MoM Growth:** April to May shows positive sales momentum, though order volume growth outpaces revenue growth — consider pricing review.

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| **Power BI Desktop** | Interactive dashboard & data visualization |
| **MySQL 8.0** | Data cleaning, transformation, and analytical queries |
| **CSV / Excel** | Raw data source |

---

*This project demonstrates end-to-end data analysis capability — from raw data ingestion and cleaning in MySQL, to interactive visualization in Power BI.*
