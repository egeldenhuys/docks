# Authentication and Authorization

## Roles
- Administrator - No restrictions, can mange the Docks settings and create new users.
  - Super User - Can use `--priviledged` and bind mounts
    - User - Cannot use bind mounts
      - Guest - Read only access. Cannot see logs or use inspect

## Resources
Resources are Stacks, and services. If a user can manage a stack, they can manage
all related services. If a user can manage a service, they can view
all related tasks.

## Security
The main security concern in the system is the Docker socket `/var/run/docker.sock`.
If a user can mount the socket, they effectively have root access
to the system, and therefore access to the swarm.

### What are the risks?

If a user account is compromised, the entire swarm is compromised. Yikes!
Do you trust Mallory to keep her password secure? How about Bob, writing
his password on a sticky note in his drawer?

The more users that have access to the socket, they greater the probability
of the swarm being compromised.

### Possible solutions
If we can completely disable bind mounts for non administrative users in Docks
then it should not be possible to gain access to the socket.

But what if the admin wants to allow a certain user/team to use bind mounts?
It can be made possible to grant permission to use bind mounts to certain
teams/users. A user with permission to bind mount can deploy stacks and services
that require bind mounts. A user that is part of a team, where a service
has been created by a `super user`, can stop and start a resource that uses
a bind mount, but should not be able to create new services/stacks that use
bind mounts.

This way the risk is limited to `super users` and the teams they are part of.
The service that makes use of the socket may still be exploited, but it is
no longer through Docks directly.

### Implementation Considerations
An association has to be made between user/team (entity) and a resource.
If an entity does not have permission to manage a resource, they have
the same permissions as a guest - read only. Tasks and Services both
make reference to the stack name in their inspect output. Tasks make
reference to the parent service. This can be used to validate if an entity
has permission (given on creation).

Any authenticated user can view Stacks, Services and Tasks in the swarm.
When an entity has been given permission to manage a Stack we associate them
with the stack name. When they try to manage a Service, Docks inspects the service
to see if they are associated with the Stack name in the service, or the
service itself.

#### Keeping State
We can either duplicate the Docker state in the Database, or query Docker
when a user wants to manage something. Query at time of management would
be simplest to implement.

## Further Reading
- [authobot](https://github.com/ndeloof/authobot)
- [Docker Run Reference - Security Configuration](https://docs.docker.com/engine/reference/run/#security-configuration)
- [Authentication Cheat Sheet](https://www.owasp.org/index.php/Authentication_Cheat_Sheet)
- [Password Storage Cheat Sheet](https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet)
