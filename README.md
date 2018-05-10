<p align="center"><img src="https://raw.githubusercontent.com/wiki/TripleParity/docks/images/logo/docks_round_512.png" width="200"></p>

# Docks

A project developed by team TripleParity

<a href="https://app.zenhub.com/workspace/o/tripleparity/docks/boards?repos=126592937,124921284,125188117,124847715,128764372,124747738" target="_blank"> ![ZenHub Badge](https://img.shields.io/badge/Shipping_faster_with-ZenHub-5e60ba.svg?style=flat-square)</a>

**Docks** provides a simple web interface for managing a Docker Swarm.
It allows you to view the status of the Swarm and the services running on it.
You can deploy Stacks and manage Services, Networks and Volumes.

With **Docks** you can securely manage a Docker Swarm using a
browser from any device, without the inconvenience of using SSH and managing
private and public keys.

## Quick Links
- <a href="https://travis-ci.org/TripleParity" target="_blank">Travis CI</a>
- <a href="https://hub.docker.com/u/tripleparity/" target="_blank">Docker Hub</a>
- <a href="https://github.com/TripleParity" target="_blank">GitHub Organisation</a>
- <a href="https://app.zenhub.com/workspace/o/tripleparity/docks/boards?repos=126592937,124921284,125188117,124847715,128764372,124747738" target="_blank">ZenHub Project Management</a> (Requires GitHub account)

### Repositories
- <a href="https://github.com/TripleParity/docks" target="_blank">docks</a> Connecting all things related to the project (start here)
  - <a href="https://travis-ci.org/TripleParity/docks" target="_blank">![Travis branch](https://img.shields.io/travis/TripleParity/docks/master.svg?label="Travis%20CI:%20master")</a>
- <a href="https://github.com/TripleParity/docks-ui" target="_blank">docks-ui</a> - The web interface for communucating with the Docks API
  - <a href="https://travis-ci.org/TripleParity/docks-ui" target="_blank">![Travis master branch](https://img.shields.io/travis/TripleParity/docks-ui/master.svg?label="Travis%20CI:%20master")</a>
  - <a href="https://travis-ci.org/TripleParity/docks-ui" target="_blank">![Travis develop branch](https://img.shields.io/travis/TripleParity/docks-ui/develop.svg?label="Travis%20CI:%20develop")</a>
- <a href="https://github.com/TripleParity/docks-api" target="_blank">docks-api</a>- The Docks API that runs on the Docker Swarm Manager Node
  - <a href="https://travis-ci.org/TripleParity/docks-api" target="_blank">![Travis master branch](https://img.shields.io/travis/TripleParity/docks-api/master.svg?label="Travis%20CI:%20master")</a>
  - <a href="https://travis-ci.org/TripleParity/docks-api" target="_blank">![Travis develop branch](https://img.shields.io/travis/TripleParity/docks-api/develop.svg?label="Travis%20CI:%20develop")</a>

### Documentation
- <a href="https://github.com/TripleParity/docs-bin/blob/master/requirements.pdf" target="_blank">Requirements and Design</a>
- <a href="https://github.com/TripleParity/docs-bin/blob/master/coding-standards.pdf" target="_blank">Coding Standards</a>
- <a href="https://github.com/TripleParity/docs-bin/blob/master/user-manual.pdf" target="_blank">User Manual</a>
- <a href="https://github.com/TripleParity/docs-bin/blob/master/testing-policy.pdf" target="_blank">Testing Policy</a>

## Getting Started
1. <a href="https://docs.docker.com/install/" target="_blank">Install Docker</a>
2. Clone `https://github.com/TripleParity/docks.git` and `cd` into `docks`
3. Run `sudo docker stack deploy -c docker-compose.yml docks`
  - Note: This might take a while as Docker has to download a large amount of data
  - This will start the **Docks API** on port `8080` and the **Docks UI** on port `4200`.
4. Browse to <a href="http://127.0.0.1:4200" target="_blank">http://127.0.0.1:4200</a> to access the web interface.
  - For more informayion see the <a href="https://github.com/TripleParity/docs-bin/blob/master/user-manual.pdf" target="_blank">User Manual</a>

## The TripleParity Team
| Team Member | Team Member | Team Member |
| :-----: | :-----: | :-----: |
| <img src="https://i.imgur.com/oQnVbm9.jpg" width=150> <br /> **Evert Geldenhuys** <a href="https://github.com/egeldenhuys" target="_blank">(GitHub)</a>| <img src="https://i.imgur.com/Oro8Itt.jpg=110x135" width=150> <br /> **Raymond De Vos** <a href="https://github.com/devosray" target="_blank">(GitHub)</a> | <img src="https://i.imgur.com/TweC9Ff.jpg" width=150> <br /> **Anna-Marié Helberg** <a href="https://github.com/annamarieHelberg" target="_blank">(GitHub)</a> |
| Team leader. Skilled in git and git workflows; writing and maintaining open source software; Linux development and deployment; Java, Python and C++. Interested in Linux, Software Testing and Automating processes. | Developer. Skilled in deployment and management of servers; Docker; MySQl and MongoDB; Git and Git workflows; NodeJS and Travis CI. Interested in Network Security and learning new technologies. | Developer. Skilled in Frontend Web developement; Backend Web developement; Database design; Javascript, CSS, Java, Android. Fast learner and Driven. Interested in Educational Software, Mobile Application Development and Integrating software with other disciplines.
| <img src="https://i.imgur.com/tmechdl.jpg" width=150> <br /> **Francois Mentz** <a href="https://github.com/FJMentz" target="_blank">(GitHub)</a> | <img src="https://i.imgur.com/iha4Z3l.jpg" width=150> <br /> **Paul Wood** <a href="https://github.com/Paulo-W" target="_blank">(GitHub)</a> | <img src="https://i.imgur.com/HsQNXZn.jpg" width=150> <br /> **Connor Armand du Plooy** <a href="https://github.com/CDuPlooy" target="_blank">(GitHub)</a> |
| Skilled in Frontend Web development; Javascript, JSON, JQuery, AngularJS; Git and Git workflows; UI Design and Database design. Driven. Interested in Web development. | Skilled in Frontend Web development; UI design; Javascript and CSS; Database design; Git and Github. Hard working and driven. Interested in Series, Artificial Intelligence and Excercise. | Skilled in Unix systems; Java, C++ and NodeJs; working with Open Source Software; Backend Web development and Git and Github. Quick learner. Interested in Low level languages, Systems Programming and Networks.
