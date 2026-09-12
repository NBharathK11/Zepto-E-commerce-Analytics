# Zepto E-Commerce Analytics

## Project Overview

This project analyzes a Zepto e-commerce product dataset to understand product assortment, pricing, discounts, customer savings, and inventory availability.

The project follows an end-to-end data analytics workflow using Python, SQL Server, and Power BI.

## Business Objectives

- Analyze the overall product assortment across categories
- Compare average selling prices across categories
- Identify categories with higher average discounts
- Analyze customer savings from discounted products
- Identify out-of-stock and low-stock products
- Identify products with the highest customer savings
- Build an interactive dashboard for business insights

## Tools & Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- SQL Server
- SQL Server Management Studio (SSMS)
- Power BI
- DAX
- GitHub

## Project Workflow

Python → SQL Server → Power BI → GitHub

### 1. Python

The dataset was analyzed and prepared using Python and Pandas.

The Python analysis included:

- Data inspection
- Missing-value validation
- Duplicate detection and removal
- Data-quality checks
- Price conversion from paise to rupees
- Customer savings calculation
- Discount categorization
- Stock-status classification
- Price categorization
- Weight categorization
- Quantity categorization
- Exploratory data analysis
- Business insights and conclusions

The cleaned dataset was exported for further SQL and Power BI analysis.

### 2. SQL Server

The cleaned dataset was imported into SQL Server for structured business analysis.

SQL analysis included:

- Overall business summary
- Product count by category
- Average selling price by category
- Average discount by category
- Price-range analysis
- Customer savings analysis
- Out-of-stock analysis
- Low-stock analysis
- Inventory-risk analysis
- CASE statements
- Ranking using window functions
- Correlated subqueries
- JOIN analysis using a category details table

### 3. Power BI

An interactive dashboard was developed using Power BI.

The dashboard includes:

- Total Products
- Total Categories
- Average Selling Price
- Average Discount %
- Total Customer Savings
- Out of Stock Products
- Products by Category
- Average Selling Price by Category
- Average Discount by Category
- Inventory Status
- Top 10 Products by Customer Savings

## Key Insights

- The dataset contains 3,730 products across 14 categories after removing exact duplicate records.
- Product assortment varies significantly across categories.
- Average selling prices differ across product categories.
- Discount levels vary across categories, with some categories offering higher average discounts.
- Customer savings can be compared across products and categories using the calculated savings metric.
- Inventory availability varies across categories, including both low-stock and out-of-stock products.
- The Power BI dashboard provides an interactive view of product, pricing, discount, savings, and inventory information.

## Repository Structure

```text
Zepto-Ecommerce-Analytics/
│
├── Python/
│   └── Zepto E-commerce_python.ipynb
│
├── Data/
│   └── zepto_cleaned_data.csv
│
├── SQL/
│   └── Zepto_Analytics.sql
│
└── PowerBI/
    └── Zepto_Ecommerce_Dashboard.pbix