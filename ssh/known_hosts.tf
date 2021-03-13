%{~ if try(login, "") != "" ~}
${login} ${file(pubkey_host)}
%{~ endif ~}

%{~ if try(x4v100, "") != "" ~}
${x4v100} ${file(pubkey_host)}
%{~ endif ~}

%{~ if try(x8a100, "") != "" ~}
${x8a100} ${file(pubkey_host)}
%{~ endif ~}
