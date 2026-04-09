# Lloyd’s Insurance Data Quality Validation Framework

🚀 End-to-end SQL-based data validation framework designed to simulate real-world insurance reporting quality checks in Lloyd’s market datasets.

---

## 📌 Overview
This project implements a comprehensive data quality validation framework using PostgreSQL and SQL, focused on insurance domain datasets including policies, claims, and bordereaux reporting.

It demonstrates how data quality issues can be proactively identified in financial systems before impacting downstream reporting and regulatory processes.

---

## 🎯 Business Context
In insurance and financial services, data quality directly impacts:
- Regulatory reporting accuracy
- Risk assessment and underwriting decisions
- Financial reconciliation and audit outcomes

This project simulates a real-world Data QA solution used in ETL validation pipelines.

---

## 🛠️ Solution Design
- Designed relational schema representing insurance entities
- Implemented SQL-based validation checks across datasets
- Simulated real-world data quality failures and detection logic

---

## 📊 Data Model
| Table | Description |
|------|-------------|
| policyholders | Customer master data |
| policies | Policy-level transactional data |
| claims | Claims and settlement records |
| bordereau | Lloyd’s premium reporting dataset |

---

## 🔍 Data Quality Checks Implemented
- Null and completeness validation
- Duplicate detection
- Referential integrity checks
- Date logic validation (policy vs claim timelines)
- Financial validation (premium and settlement checks)
- Domain validation (status values)
- Source-to-target reconciliation (bordereaux)

---

## 📈 Key Findings
- Identified multiple critical data quality issues including:
  - Duplicate policy records
  - Missing premium values
  - Invalid claim settlement logic
  - Orphan records across relational tables
- Demonstrated how automated SQL checks can detect high-risk data issues early in pipelines

---

## 🧰 Tech Stack
- PostgreSQL
- SQL
- DBeaver (querying & validation)
- Data Quality Testing Framework Design

---

## 📁 Project Structure

---

## 💡 Key Skills Demonstrated
- Data Quality Engineering
- SQL-based Validation Frameworks
- ETL Testing & Validation
- Financial Data Reconciliation
- Root Cause Analysis of Data Issues

---

## 👤 Author
Rama Krishna Bashamoni  
Senior Data QA Engineer | London, UK
