# docks-demo

Docks provides a web interface for managing a [Docker Swarm](https://docs.docker.com/engine/swarm/key-concepts/).

For documentation see [docs](https://github.com/TripleParity/docs)


Docks consists of two main components:
- [docks](https://github.com/TripleParity/docks) - REST API to communicate with Docker running on the Swarm Manager
- [docks-ui](https://github.com/TripleParity/docks-ui) - Web interface which communicates with the Docks API to manage the Swarm


## Usage Instructions
1. [Install Docker](https://docs.docker.com/install/)
2. [Install Docker Compose](https://docs.docker.com/compose/install/)
3. Make sure the [Docker daemon](https://docs.docker.com/config/daemon/) is running
4. Clone this repository
5. Run `sudo docker-compose up -d` in the `docks-demo` folder that was cloned
  - This will start the Docks API on port `8080` and the web server on port `4200`
  - To view the output of the Dock API and web server, omit the `-d` flag
  - **Note**: Docker has to download a large amount of data. The process can take up to 30 minutes depending on your internet speed.
6. Browse to http://127.0.0.1:4200 to access the web interface.
7. To view running containers click the `Submit` button in the demo web interface
8. Run `sudo docker-compose down` in the `docks-demo` folder to stop the running containers (docks and docks-ui)

## Warning
The API currently exposes the Docker API without authentication.
Whoever has access to port `8080` or `4200` will effectively have root access.

This will change in the future.
