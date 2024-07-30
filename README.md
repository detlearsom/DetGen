# DetGen: Somewhat Deterministic Traffic Generation

## What is this?

DetGen is a set of scripts and conventions for capturing network traffic and logging information from self-contained
"scenarios" which are run inside Docker containers.  The scenarios can be easily re-run to regenerate traffic with
or without variation.  In contrast to capturing traffic from general VMs or actual workstations, the captures are 
repeatable and more determinstic.  We have used this framework for research on synthetic data for
Network Intrusion Detection.

## How do I use it?

We recommend setting up in an Ubuntu instance:

1. Install Docker on your Ubuntu machine following these instructions:  
   <https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository>
2. Install docker-compose following:  
   <https://docs.docker.com/desktop/install/linux-install/>
3. Clone this repository into a working directory:  
   `git clone https://github.com/detlearsom/DetGen`
4. Build all the containers:  
   `cd containers; sudu make all`

To run scenarios, look at the control scripts inside the `captures` directory.

## Datasets

For some Datsets used for publications in the
[Detlearsom project](https://detlearsom.github.io/), please look for instructions [here](README-datasets.md)


## Release History

### Release 1.0.0 (April 2021)

This release contains all scenarios that are in a well-maintained state, namely:

1. HTTP
2. FTP
3. SSH
4. File-Sync
5. BitTorrent
6. SQL
7. IRC
8. NTP
9. Music and Video streaming

and the following attack scenarios:

1. SQL-injections
2. Heartbleed
3. XXE attacks

We have a number of additional scenarios and supporting software in
other working repositories.  Please contact us if you are interested.

### Release 1.0.1 (August 2024)

* Minor updates to documentation and to scripts for compatibility
* Deprecation of prototype GUI interface



## Publications

Please cite the following paper when using DetGen in your research:

> *Traffic generation using containerization for machine learning*. Henry Clausen, Robert Flood, and David Aspinall. Workshop on DYnamic and Novel Advances in Machine Learning and Intelligent Cyber Security (pp. 1-12), December 2019.

DetGen is also used in work including:

> *Evading stepping-stone detection with enough chaff*. Henry Clausen, Michael Gibson, David Aspinall.  Conference on Network and System Security, November 2020

> *Examining traffic microstructures to improve model development*. Henry Clausen and David Aspinall. 2021 IEEE Security and Privacy Workshops (SPW), May 2021 

> *CBAM: A Contextual Model for Network Anomaly Detection.* Henry Clausen, Gudmund Grov, and David Aspinall. MDPI Computers 2021 (MDPI), June 2021

> *Controlling network traffic microstructures for machine-learning model probing*. Henry Clausen, Robert Flood, and David Aspinall. 17th EAI International Conference on Security and Privacy in Communication Networks (SecureComm 2021), September 2021.

> *Bad Design Smells in Benchmark NIDS Datasets*.   Robert Flood, Gints Engelen, David Aspinall, Lieven Desmet.  9th IEEE European Symposium on Security and Privacy, EuroS&P, July 2024. (winner of the **Distinguished Paper Award**)


## License and contributions

### Contributions

The main authors are Henry Clausen, Robert Flood and David Aspinall.
Thanks to further contributors for feedback, testing and extensions:

* Gudmund Grov
* Anthos Makris

Further contributions or notes of how you are using DetGen would
be very welcome.  Please contact [David Aspinall](mailto:David.Aspinall@ed.ac.uk)
in the first instance.


### License

This project is licensed under the terms of the MIT license.

Copyright (c) 2019-2024 University of Edinburgh and contributors.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


