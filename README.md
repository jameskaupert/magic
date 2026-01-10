# Magic Setup
Repo for quickly setting up my machines - like *magic*!

Uses Ansible to achieve desired state. Continual work in progress.

Currently just for Arch Linux using Niri.

## Mental Model (work in progress)
Layer 1: Bootstrap - anything to get the machine into the state to do the rest of the setup
Layer 2: Base - anything every machine might need
Layer 3: Shared - anything specific machines (ie: desktop workstations) might need, agnostic to user
Layer 4: Personal - my specific apps and preferences

These layers exist to guide my thinking on which things belong together.

## Installation
Clone the repo, `cd` into magic folder, then:
```
sudo pacman -Syu ansible
ansible-playbook workstation.yml -K
```
