# Box Store E-Commerce Database

E-commerce database system managing customer orders, inventory, transactions, and multi-manufacturer relationships.

## Business Problem

Box Store needed a scalable relational database to support:
- Customer order processing and tracking
- Multi-manufacturer inventory management
- Payment transaction handling
- Geographic data for shipping and tax calculations
- Employee and department organization

## Solution Overview

Designed a normalized MySQL database with 15+ interconnected tables supporting end-to-end e-commerce operations.

## Data Model

The entity-relationship diagram shows the complete database schema:

![Box Store ERD](boxstore-erd.png)

### Core Entities

- **people**: Customer and employee information
- **orders**: Customer purchase orders with line items
- **items**: Product catalog from multiple manufacturers
- **manufacturer**: Vendor information and addresses
- **transactions**: Payment processing and records
- **category**: Department and product categorization
- **geo_*** tables: Geographic hierarchy (country → region → town/city)

### Key Relationships

- Customers (people) place Orders (1:many)
- Orders contain Items (many:many via orders__item junction table)
- Items belong to Manufacturers (many:1)
- Employees belong to Departments (many:many via category__people)
- Orders have Transactions (many:many via order__transactions)
- Geographic data supports address validation and tax calculation

## Technical Features

### Database Design
- Normalized schema (3NF) minimizing data redundancy
- Foreign key constraints ensuring referential integrity
- Junction tables for many-to-many relationships
- Hierarchical geography model (country → region → city)

### Business Logic Implementation
- Automated tax calculation (GST/PST) using views
- Price history tracking for items (sale vs. regular pricing)
- Receipt generation from order data
- Transaction audit trail
- Employee-manager relationships

### Key Queries
- Complex multi-table JOINs for order processing
- Receipt generation with tax calculations
- Inventory tracking across manufacturers
- Customer order history and analytics

## Files

- `hs_0394114_boxstore_f.sql` - Complete database schema and sample data
- `boxstore-erd.png` - Entity-relationship diagram

## Technologies

- **Database**: MySQL
- **Tools**: MySQL Workbench, draw.io
- **Concepts**: Relational database design, normalization, foreign keys, views, complex queries

## Business Impact

This database structure enables:
- Accurate order processing with automated pricing
- Multi-jurisdiction tax compliance (GST/PST)
- Scalable inventory management across vendors
- Complete transaction audit trail
- Data-driven business reporting and analytics

## Project Context

Academic project demonstrating database design, SQL proficiency, and business requirements analysis. Designed to support a fictional e-commerce operation with realistic constraints and relationships.

---

**Status**: Completed (2023)  
**Author**: Hamed Sharafeldin
