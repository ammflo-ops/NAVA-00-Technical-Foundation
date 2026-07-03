# 00 Technical Foundation

### Shared SQL Architecture

This repository contains the shared SQL architecture powering the entire [**NAVA Business Intelligence Portfolio**](https://github.com/ammflo-ops/NAVA-Business-Intelligence-Portfolio/blob/main/README.md).

It provides a centralized data warehouse, reusable analytical views and standardized business logic that support all analytical projects across Sales, Budget and Marketing.

---

# 🏗️ Data Architecture

The solution follows a multi-layer SQL architecture designed to transform raw operational data into reliable, business-ready datasets.

<p align="center">
  <img src="../assets/data_architecture.png" width="900">
</p>

---

# 📖 Overview

The technical foundation was designed around a single objective:

> **Build once. Reuse everywhere.**

A shared SQL architecture ensures that all business projects rely on the same business definitions, transformation logic and analytical datasets.

---

## ✨ Design Principles

The architecture is based on three core principles:

| Principle | Description |
|-----------|-------------|
| **Reusability** | Shared SQL components and analytical views are designed to support multiple business use cases. |
| **Consistency** | Standardized business logic and KPIs ensure consistent reporting across all dashboards. |
| **Reliability** | Data quality controls and ETL validation produce trusted, business-ready datasets. |

---

## 🚀 Key Capabilities

- Shared SQL architecture supporting multiple business domains
- Multi-layer Data Warehouse *(Raw → Clean → Analytics)*
- Modular ETL pipelines
- Reusable analytical SQL views
- Integrated data quality controls
- Tableau-ready analytical datasets

---

# 📂 Repository Structure

```text
00_Technical_Foundation
│
├── datasets/
│
├── scripts/
│   ├── raw_layer/
│   ├── clean_layer/
│   ├── analytics_layer/
│   └── data_quality/
│
└── README.md
```

---

# 📚 Repository Contents

| Folder | Description |
|--------|-------------|
| **datasets** | Source CSV files used throughout the project |
| **raw_layer** | Raw data ingestion scripts |
| **clean_layer** | Data cleansing, standardization and business transformations |
| **analytics_layer** | Business-ready SQL views used by Tableau dashboards |
| **data_quality** | SQL validation scripts and quality checks |

---

# 💡 About

This repository represents the technical foundation of the **NAVA Business Intelligence Portfolio**.

Its purpose is to provide a scalable, reusable and reliable SQL architecture that enables consistent reporting and supports multiple business-oriented analytical projects.
