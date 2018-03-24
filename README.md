# docks-demo

Docks provides a web interface for managing a [Docker Swarm](https://docs.docker.com/engine/swarm/key-concepts/).


Docks consists of two main components:
- `docks` - REST API to communicate with Docker running on the Swarm Manager
- `docks-ui` - Web interface which communicates with the Docks API to manage the Swarm

## Usage Instructions
1. [Install Docker](https://docs.docker.com/install/)
2. [Install Docker Compose](https://docs.docker.com/compose/install/)
3. Run `sudo docker-compose up` in the docks-demo git directory
4. Browse to http://127.0.0.1:4200 to access the web interface. The API will be running on port `8080`

## Warning
The API currently exposes the Docker API without authentication.
Whoever has access to port `8080` on your computer will effectively have root access.

This will change in the future.
