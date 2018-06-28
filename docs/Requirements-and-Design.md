# Requirements and Design

**TODO**:
- [ ] Discuss each requirement and create derived requirements
- [ ] Decide whether to create issues spawned from this document or keep this document intact
- [ ] Decide on input method for [Deploy Service](#deploy-service)
- [ ] Stack file management for [Deploy stack](#deploy-stack)
    - How will we know which stack file relates to which stack
- [ ] Data structures for transferring stack and service configurations

----

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=3 orderedList=false} -->

<!-- code_chunk_output -->

* [The Problem](#the-problem)
* [The Solution](#the-solution)
* [Team Limitations](#team-limitations)
* [Project Limitations](#project-limitations)
* [Docker Based Requirements](#docker-based-requirements)
	* [Create](#create)
	* [Update](#update)
	* [Remove](#remove)
	* [View](#view)
* [Security Requirements](#security-requirements)
* [Team Requirements](#team-requirements)
* [User Management Requirements](#user-management-requirements)
* [Design](#design)
	* [Configuring Stacks and Services](#configuring-stacks-and-services)
	* [Updating services outside of Docks](#updating-services-outside-of-docks)
	* [Using existing networks in compose file](#using-existing-networks-in-compose-file)
	* [Deploy Stack](#deploy-stack)
	* [Deploy Service](#deploy-service)
	* [Create Network](#create-network)
	* [Create Volume](#create-volume)
	* [Pre-configured Stacks](#pre-configured-stacks)
	* [Update Stack](#update-stack)
	* [Update Service](#update-service)
	* [Remove Stack](#remove-stack)
	* [Remove Service](#remove-service)
	* [Remove Network](#remove-network)
	* [Remove Volume](#remove-volume)
	* [View Stacks in Swarm](#view-stacks-in-swarm)
	* [View Services in Swarm](#view-services-in-swarm)

<!-- /code_chunk_output -->

----

The purpose of this document is to explore the requirements of the project and provide potential solutions. Issues will be created based on this document. It can be seen as a seed for issues and discussions and does not reflect the final implementation or requirements.

**Note:** [Docker Engine API 1.24](https://docs.docker.com/engine/api/v1.24/) will be considered in writing this document as it is the latest version that does not throw JavaScript errors when viewing. If it works on your system let us know!

## The Problem
- SSH access to a manager node is not always possible or convenient
- While Docker CLI is extremely powerful, it requires experience and knowledge to use effectively
- Docker CLI requires multiple commands to perform simple tasks

## The Solution
- Expose the essential management functions using a web interface

## Team Limitations
- Lack of experience with distributed systems and technologies

## Project Limitations
- Designed to be deployed on a single manager node.
    - Docks API is not a distributed system.

## Docker Based Requirements
### Create
- [ ] [Deploy stack](#deploy-stack) - 0
    - [ ] API to deploy stack, given:
        - Stack file contents
        - Stack name
    - [ ] Deploy Stack page
- [ ] [Deploy service](#deploy-service) - 0
    - [ ] Data flow model
    - [ ] Deploy Service Page
- [ ] [Create network](#create-network) - 1
    - [ ] Create Network Page
        - Network name
        - Driver
- [ ] [Create volume](#create-volume) - 1
    - [ ] Create Volume page
        - Volume name
        - Driver
        - Driver options
- [ ] [Pre-configured Stacks](#pre-configured-stacks) - 1
    - Delayed for now

### Update
- [ ] [Update Stack](#update-stack) - 0
    - [ ] Update stack page (same as deploy stack)
- [ ] [Update service](#update-service) - 0
    - [ ] Update service page (same as deploy service)

### Remove
- [ ] [Remove stack](#remove-stack) - 0
- [X] [Remove service](#remove-service) - 0
- [ ] [Remove network](#remove-network) - 1
- [ ] [Remove volume](#remove-volume) - 1

### View
- [ ] [View stacks in swarm](#view-stacks-in-swarm) - 0
    - [ ] Stack View Page
        - Stack name
        - Number of services
- [X] [View services in swarm](#view-services-in-swarm) - 0
    - [ ] Services View Page
        - Service name
        - Associated stack
        - Replicas
        - Image
- [ ] [View tasks in a service](#view-tasks-in-a-service) - 0
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

#### Reverse engineering inspect info
If we can create a compose file from the inspect info, we do not even have to store
stack files in the database. Everything can be extracted from the swarm state.

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

Note on user friendliness: A form is much more friendly than a free style text area.

### Create Network

Some services require networks to exist before creating the service.
These networks can be created by another stack/service or manually using the CLI.
It will be more convenient to create the network apart from any service

The problem I see with only allowing networks to be created through stack files
is that they will be managed by compose. Networks managed by compose will be
destroyed when the stack is removed or an error will be thrown if the network is in use.

Therefore it is necessary to create standalone networks.

The most common network I have had to create was a `bridge` or a `overlay` network.

Parameters:
- Network name
- Driver

### Create Volume
By default volumes in the swarm will be specific to the host (using the `local` driver).
For volumes that are shared across the swarm need to use a driver such as
[REX-Ray](https://rexray.thecodeteam.com) that is swarm aware.

Parameters:
- Network name
- Driver
- Driver options

Creating a local volume will create a volume that only exists on the host machine
running the task. In most cases this is now how you would use a swarm or
deploy a distributed application.

It also does not make sense to create a standalone volume using the local
driver, as this would be created on the manager node hosting the Docks API.

### Pre-configured Stacks
Some stacks I deploy often, such as traefik and in the future fail2ban.

The stack configuration should be stored on the back-end and requested by the front-end
The simplest would be to send the stack name and stack data to the back-end
to be created instead of keeping reference to the stack configuration.
This also allows the user to modify the stack file before deploying.

Once a pre-configured stack is selected, the same interface for deploying a stack
can be used.

A nice feature would be the ability to add stacks to the list.

### Update Stack
Given a stack file and stack name it should be possible to update a deployed stack.

The same interface can be used as Deploy Stack, except instead of checking for duplicate
stack name, the name should already exist to avoid confusion.

The back-end can provide helper functions for checking if a stack exists

### Update Service
Once a service has been deployed it should be possible to update the service specs.

The same interface as Deploy Service can be used.
In order to get the current service spec the inspect info can be reverse engineered
into an intermediate model. The model can then be used to populate or create a form
in the front-end.

The intermediate model will then have to be converted into a form compatible with
the Docker API. If possible the intermediate model can already be compatible with
the Docker API.

### Remove Stack
It should be possible to remove a deployed stack from the swarm.
The action can be initiated from the stack list view.

### Remove Service
It should be possible to remove a service that has been deployed to the swarm.
The action can be initiated from the service list view

### Remove Network
Can be initiated from the network list view

### Remove Volume
Can be initiated from the volume list view

### View Stacks in Swarm
As with the CLI, it should be possible to view stacks that are deployed to the
swarm.

Information includes:
- Stack name
- Number of services

On this view we can also have initiate the actions for delete and edit a stack.

### View Services in Swarm
Information that should be immediately visible:
- Service name
- Associated stack
- Replicas
- Image

Actions on services:
- Edit (includes scale, but quick edit can be added for scale)
- Remove
- View Tasks
- View log

### View Tasks in a Service
Viewing all tasks in the swarm is overwhelming as historic tasks are also displayed by default.

Tasks that are running under a service should be viewable.

Actions on Tasks:
- View log