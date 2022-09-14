[login]
%{ if try(login, "") != "" ~}
login-[0000:${format("%04d", length(split(",", login)) - 1)}]
%{ endif ~}

[x4v100]
%{ if try(x4v100, "") != "" ~}
x4v100-[0000:${format("%04d", length(split(",", x4v100)) - 1)}]
%{ endif ~}

[x8v100]
%{ if try(x8v100, "") != "" ~}
x8v100-[0000:${format("%04d", length(split(",", x8v100)) - 1)}]
%{ endif ~}

[x8a100]
%{ if try(x8a100, "") != "" ~}
x8a100-[0000:${format("%04d", length(split(",", x8a100)) - 1)}]
%{ endif ~}

[compute:children]
x4v100
x8v100
x8a100

### SLURM ###

[slurm_controller:children]
login

[slurm_client:children]
login

[slurm_compute:children]
compute

### NFS ###

[nfs_server:children]
login

[nfs_clients:children]
compute
