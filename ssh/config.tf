Host *
  User ${user}
  PasswordAuthentication no
  CheckHostIP yes
  StrictHostKeyChecking yes
  IdentityFile ${abspath(privkey)}
  UserKnownHostsFile ${abspath(known_hosts)}

%{ if try(login, "") != "" ~}
%{~ for i, ip in split(",", login) ~}
Host login-${format("%04d", i)}
  Hostname ${ip}
%{ endfor ~}
%{~ endif ~}

%{ if try(x4v100, "") != "" ~}
%{~ for i, ip in split(",", x4v100) ~}
Host x4v100-${format("%04d", i)}
  ProxyJump login-0000
  Hostname ${ip}
%{ endfor ~}
%{~ endif ~}

%{ if try(x8a100, "") != "" ~}
%{~ for i, ip in split(",", x8a100) ~}
Host x8a100-${format("%04d", i)}
  ProxyJump login-0000
  Hostname ${ip}
%{ endfor ~}
%{~ endif ~}
