TODO:
- [ ] Discuss each requirement and create derived requirements
- [ ] Decide whether to create issues spawned from this document or keep this document intact
- [ ] Decide on input method for [Deploy Service](#deploy-service)

----

The purpose of this document is to explore the requirements of the project and provide potential solutions. Issues will be created based on this document. It can be seen as a seed for issues and discussions and does not reflect the final implementation or requirements.

**Note:** [Docker Engine API 1.24](https://docs.docker.com/engine/api/v1.24/) will be considered in writing this document as it is the latest version that does not throw JavaScript errors when viewing. If it works on your system let us know!

## The Problem
- SSH access to a manager node is not always possible or convenient
- While Docker CLI is extremely powerful, it requires experience and knowledge to use effectively
- Docker CLI requires multiple commands to perform simple tasks

## The Solution
- Expose the essential management functions using a web interface

## Docker Based Requirements
### Create
- [ ] [Deploy stack](#deploy-stack) - 0
- [ ] [Deploy service](#deploy-service) - 0
- [ ] [Create network](#create-network) - 0
- [ ] Create volume - 1
- [ ] Pre configured stacks, EG: - 1
    - Traefik
    - Prometheus
    - Postgres
    - Mongodb
    - Registry
    - fail2ban?

### Update
- [ ] Update stack - 0
- [ ] Update service - 0

### Remove
- [ ] Remove stack - 0
- [X] Remove service - 0
- [ ] Remove network - 0
- [ ] Remove volume - 1

### View
- [ ] View stacks in swarm - 0
    - Stack name
    - Number of services
- [X] View services in swarm - 0
    - Service name
    - Associated stack
    - Replicas
    - Image
- [ ] View tasks in a service - 0
- [X] View tasks in the swarm - 1
    - Perhaps only view the latest version of the task?
- [ ] View networks - 1
    - Name
    - Driver
    - Scope
- [X] View volumes - 1
    - Name
    - Driver
- [X] View logs for service - 0
- [ ] View logs for task - 0
- [ ] View nodes in the swarm - 0
    - Hostname
    - Status
    - Availability
    - Manager Status
    - Engine version

## Security Requirements
- [X] Only authenticated users may communicate with Docks API - 0
- [ ] Access control for operations - 2
- [ ] Users may only perform operations for which they are authorized - 2
- [ ] Audit log - 0
- [ ] Two Factor Authentication - 3
- [ ] Ability to use fail2ban to prevent brute force attacks - 0

## Team Requirements
- [ ] Team based roles - 2
    - [ ] Team Leader
        - Create and add users into managed team
    - [ ] Super User
        - Deploy and remove
        - Bind mounts
    - [ ] Normal User
        - Deploy and remove
    - [ ] Guest
        - No access to sensitive information
        - Cannot deploy or remove
        - Should only be able to view
- [ ] Global roles - 2
    - [ ] Admin
        - No restrictions - can modify any resource
        - Treat as `root`
        - Change potential Docks settings
- [ ] Admin can create and manage teams - 2
- [ ] Team leader can add users to team - 2

## User Management Requirements
- [ ] Create new users given `username/password` - 0
- [ ] User can change own password - 0
- [ ] Admin can change other's password - 0
- [ ] Delete user - 0

## [WIP] Derived component requirements
### Docks API
- [ ] Provide API to deploy stack, given: [(deploy stack)](#deploy-stack)
    - Stack file
    - Stack name

### Docks UI
- [ ] Upload stack file [(deploy stack)](#deploy-stack)
- [ ] Create stack file using text area [(deploy stack)](#deploy-stack)

## Design
Design and implementation discussions.

### Configuring Stacks and Services
One way is to provide a form for setting up and modifying stacks and services, however given the amount of options this would be unreasonable.

A better solution would be to use a compose file for stacks and services.
This gives the user full flexibility to deploy whatever they want and also to use existing compose files. Stand alone services created using a compose file can be tagged by Docks to exclude being listed in the stacks view. 

### Updating services outside of Docks
- Storing the compose file in the database and then having the stack/service manually rolled back. Perhaps associate the config with the service version
    - The service contains a `PreviousSpec` section in the inspection.
    - When a config is modified using the Docks interface, and updated at field is stored with the file. This can then be compared with the service's updated at. If the services was updated outside of Docks we can notify the user that the config on Docks might not be the latest - they should consult the system administrator.

### Using existing networks in compose file
Some services may require attaching to an existing network that is created outside of docker-compose

We need to provide an interface for creating networks.
Perhaps auto generate a form from JSON schema?

### Deploy Stack
Docker API does not expose functionality for working with stacks.
The Docker CLI needs to be wrapped, it is not preferable but the easiest way to implement this functionality. The alternative is to rewrite the [code used by Docker CLI](https://github.com/moby/moby/blob/5706d8206bd41fca36ed634f80fe85f5ffbed71b/cli/command/stack/deploy.go)

Docks API will expose functions to call the CLI. Extreme care should be taken to sanitize the input as we will be executing it.

The user will upload a stack file to be stored in the database. This file will then be used as an argument for the CLI, therefore it will need to be written to the disk temporarily.

The stack file can be uploaded as a file or input as text in a text area. This will also be used for deploying services later.
It will be most flexible to allow the user also to retrieve the stack file from the database and edit in Docks UI, relieving the burden of creating a complex form.

Error handling needs to be considered as well - the CLI is required on the host. Stack file errors need to be reported from the CLI to the user.

##### Derived requirements
- [docks-api](#docks-api)
- [docks-ui](#docks-ui)

### Deploy Service
Due to the flexible configuration allowed for services, it would be easiest to also use stack files for deploying standalone services.

If a user wishes to deploy a standalone service from scratch they may write a compose file for it. We can help them by pre populating the structure if required.

The problem with treating services as stacks is that there will be two types of services. Services created by Docks and those by Docker. The user will be able to edit the Docks services as they were created from a stack file, however Docker services will not have a source file.

The inspect command should contain all the required information so it is possible to reverse engineer the parameters used to start the service.
See [nexdrew/rekcod](https://github.com/nexdrew/rekcod)

Presenting the user with a form for all possible parameters may be overwhelming. Either we present them with a subset of operations at the cost of less flexibility, or the user determines what configuration parameters to set.

#### User input
##### Option 1: Stack File Editor
- The service is defined using a stack file. Docks API will convert the stack file into the appropriate Docker request.
- To update the service the inspect output is reverse engineered into the corresponding stack file. Possibly stripping unused parameters and unrelated fields. The stack file is modified in the browser and sent back to Docks API, which will again convert it to a request for Docks.

This has the advantage that if we can translate between the two schemas, we can accommodate any configuration.

This option has the advantage that the user can copy and paste parts from a docker compose file straight into Docks and deploy it.

##### Option 2: Minimal Form
If the user does not want to deploy a stack with full flexibility they can use the minimal form to deploy a standalone service.

Fields:
- Service name
- Image
- Ports
- Env
- Mounts
    - Bind
    - Volumes
- Labels
- Networks
- Mode
- Replicas
- Constraints

The above list is by no means small, yet those are the essentials fields I use for the most basic server setup. As soon as you take away any of these you lose an important aspect of swarm management (in my opinion)

Perhaps initially the user is presented with:
- Service name
- Image
- Ports

and then the ability to add other fields as they require. This requires a model of the schema used by Docks. If we can translate the schema we can accommodate for any configuration.

The disadvantage of using a form instead of a stack file editor is the user has to translate widely available docker-compose files into our forms model.

##### Case Study: Visual Studio Code Preferences
In my VSCode config, there are 681 key-value pairs that can be set.
The keys are conveniently indexed based on the component they relate to, for example "editor.tabsize", "editor.cursorStyle".

Preferences can be searched for using a search bar, causing only matching keys to be displayed. Furthermore preferences are grouped based on "common settings", "git", etc.

By editing the preferences presented in plain text that can be searched, flexibility is offered that is not possible with forms.

##### Compromise: Creation by stack file, quick edit by form
A middle ground would be to implement the stack file editor and reverse engineer the inspect output and also have form based input for small changes. This can be used for full flexibility deployments and updates.

Then for simple changes a form can be presented. For example quick scaling or updating an image.

##### Conclusion
- Stack file editor
    - provides flexibility as it allows any configuration, even invalid configurations.
    - provides usability as the user can copy and paste from existing docker-compose files
    - will require more effort on mobile devices
    - requires reverse engineering the `inspect` output
    - can be used for stacks and services
- Form input
    - can overwhelm the user if all fields are presented at once - see Portainer
    - requires the user to rewrite existing docker-compose files into our form
    - is more user friendly as we can provide relevant constraints on data types - spinner for replicas, dropdown for mode etc
    - will require modeling the Docker API schema partially or fully. This is probably less complex than reverse engineering the schema. Although the inspect output still has to be reverse engineered for specific fields

### Create Network

Some services require networks to exist before creating the service.
These networks can be created by another stack/service or manually using the CLI.
It will be more convenient to create the network apart from any service

The problem I see with only allowing networks to be created through stack files
is that they will be managed by compose. 