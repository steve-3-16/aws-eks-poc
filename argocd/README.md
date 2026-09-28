# Argo CD

This directory contains Argo CD configuration for the Amazon EKS environment.

## Purpose

Argo CD is used for GitOps-based continuous delivery to Amazon EKS.

Git is used as the source of truth for Kubernetes deployment configuration.

## Deployment Flow

```text
GitHub
   |
   v
GitHub Actions
   |
   v
Amazon ECR
   |
   v
Git Manifest Update
   |
   v
Argo CD
   |
   v
Amazon EKS# Argo CD

This directory contains Argo CD configuration for the Amazon EKS environment.

## Purpose

Argo CD is used for GitOps-based continuous delivery to Amazon EKS.

Git is used as the source of truth for Kubernetes deployment configuration.

## Deployment Flow

```text
GitHub
   |
   v
GitHub Actions
   |
   v
Amazon ECR
   |
   v
Git Manifest Update
   |
   v
Argo CD
   |
   v
Amazon EKS
