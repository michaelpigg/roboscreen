Roboscreen is an Asterisk-based system to screen out unwanted robocallers. It does this by asking callers whose caller ID is not known good to prove that they are human by pressing a randomly chosen key.

## Hardware
The current version was developed with the BeagleBone Black and Grandstream HT503 ATA. It should operate with any equivalent hardware, however.

## Getting Started
1. Create `private/secrets.yml` as follows, replacing `<pwd>` with your own passwords:
```
ht503fxo_pwd: <pwd>
ht503fxs_pwd: <pwd>
```
2. Record the following message files (8kHz, 16 bit, WAV):
  1. MainGreeting.wav
  2. NotRecognized.wav
  3. CountinuePleasePress.wav
3. Configure HT503 appropriately
  1. Basic: Unconditional call forward
  1. FXO: Server and credentials
  1. FXO: Turn off ring through to FXS
  1. FXO: Set rings to 2
  1. FXS: Server and credentials

## Development
A Vagrantfile is provided for development on a virtual machine. An Ansible playbook provisions the system by installing Asterisk and Lua, then customizing the Asterisk installation. Key files such as sip.conf and extensions.lua are symlinked so that they can be edited locally.

## TODOs
* Monitoring
* Support automatic provisioning of HT503
* Provide generic message files
* Provision real installation via Ansible
* Provide a better UI for managing whitelist
