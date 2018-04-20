# Docks

Docks provides a web interface for managing a [Docker Swarm](https://docs.docker.com/engine/swarm/key-concepts/).

For system and architecture documentation see [docs-bin](https://github.com/TripleParity/docs)

Docks consists of two components:
- [docks-api](https://github.com/TripleParity/docks-api) - REST API to communicate with Docker Engine running on the Swarm Manager
- [docks-ui](https://github.com/TripleParity/docks-ui) - Web User Inteface for communicating with the Docks API to view and manage the swarm

## Usage Instructions
1. [Install Docker](https://docs.docker.com/install/)
2. [Install Docker Compose](https://docs.docker.com/compose/install/)
3. Make sure the [Docker daemon](https://docs.docker.com/config/daemon/) is running
4. Clone this repository (or download the `docker-compose.yml` file)
5. Run `sudo docker-compose up -d` in the `docks` folder that was cloned
  - This will start the Docks API on port `8080` and the web server on port `4200`
  - Docker Images will be pulled for the latest stable versions of the API and the web interface
  - To view the output of the Dock API and web server, omit the `-d` flag
  - **Note**: Docker has to download a large amount of data. The process can take up to 30 minutes depending on your internet speed.
6. Browse to http://127.0.0.1:4200 to access the web interface.
8. Run `sudo docker-compose down` in the `docks` folder to stop the running containers (docks-api and docks-ui)
