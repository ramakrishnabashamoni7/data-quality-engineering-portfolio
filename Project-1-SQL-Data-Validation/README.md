# Project 1: Lloyd's Market Insurance Data Validation

## Overview
A complete SQL-based Data QA test suite built on a realistic
Lloyd's insurance market dataset. Demonstrates core data quality
validation skills used in financial services ETL testing.

## Tech Stack
- PostgreSQL 16
- DBeaver
- SQL

## Tables
| Table | Rows | Description |
|-------|------|-------------|
| policyholders | 15 | Insurance customers |
| policies | 15 | Insurance policy records |
| claims | 15 | Claims raised against policies |
| bordereau | 15 | Lloyd's syndicate premium reports |

## QA Tests Implemented
| # | Test | Issues Found | Severity |
|---|------|-------------|----------|
| 1 | Null Check | 2 | Critical |
| 2 | Duplicate Check | 2 | Critical |
| 3 | Future Date Check | 1 | High |
| 4 | Null Premium Check | 1 | Critical |
| 5 | Negative Premium Check | 1 | Critical |
| 6 | Invalid Status Check | 1 | High |
| 7 | Date Logic Check | 1 | Critical |
| 8 | Orphan Record Check | 1 | Critical |
| 9 | Settlement Exceeds Claim | 2 | Critical |
| 10 | Bordereau Reconciliation | 4 | Critical |

## Key Skills Demonstrated
- Null and completeness checks
- Duplicate detection
- Referential integrity validation
- Cross field date logic validation
- Financial reconciliation
- Domain value checks
- Source to target reconciliation
- Lloyd's bordereaux validation

## Author
Rama Krishna Bashamoni
Senior Data QA Engineer | London, UK