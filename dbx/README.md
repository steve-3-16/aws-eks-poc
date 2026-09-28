# Databricks

This directory contains Databricks-related configurations and documentation for the POC.

## Purpose

Databricks is used for data and AI workloads integrated with the AWS private infrastructure.

## Planned Components

- Databricks Workspace Integration
- Private Network Connectivity
- Databricks PrivateLink
- Unity Catalog
- Mosaic AI Vector Search
- AI / RAG Integration

## Planned AI Flow

```text
AI Agent
   |
   v
RAG Pipeline
   |
   v
Embedding
   |
   v
Databricks Vector Search
   |
   v
Retrieved Context
   |
   v
LLM
