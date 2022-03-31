# simpoint_openc910
modified openc910 for the simpoint purpose, some changess to the original openc910 git repo

# Main changes
(1) added the dpi interface to the mem_ctrl.v for loading the check point memory snapshot into the RAM (Distributed to the 16 RAM banks)

(2) added a dpi interface to the ram.v to load and set the content of the RAM
