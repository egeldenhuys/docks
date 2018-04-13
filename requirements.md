# Requirements

This document will discuss the requirements and the architecture
of the project.

## Definitions
1. Docks - All subsystems that make up the project.
2. Docks API - The REST API server running on a Manager Node.
3. Docks UI - The web interface for user interaction.
4. Docker API - The API for managing Docker.

## Introduction
Docks provides a web interface for managing a Docker Swarm using
the Docker API. Docks builds on the Docker API to provide
visualisations of the Docker Swarm.

## Architecture
Docks consists of two main sub systems:
- Docks API
- Docks UI

The Docks UI subsystem will have a N-Tier architecture. It consists of components
that deligate...

## Requirements
1. Authentication - A user must be authenticated and authorized
before interacting with the Docks API
2. View nodes in the Swarm
3. View Containers on Nodes (running and stopped)
4. View running Services
5. View running Stacks
6. Remove a Service from the Swarm
7. Remove a Stack from the Swarm
8. Deploy a Service to the Swarm
9. Deploy a Stack to the Swarm
10. User Management
  1. CRUD

----

## TODO
- [ ] Follow SRS format (@egeldenhuys, 2018-04-10)
- [ ] Clarify on Services and Stacks (@egeldenhuys, 2018-04-10)
